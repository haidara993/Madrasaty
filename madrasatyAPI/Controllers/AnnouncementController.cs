using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using madrasaty1.Data;
using madrasaty1.Dtos;
using madrasaty1.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace madrasaty1.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    public class AnnouncementController : ControllerBase
    {
        public DataContext _context { get; set; }
        public IMapper Mapper { get; set; }
        protected HttpClient ClientFireBase;
        public AnnouncementController(DataContext _context, IMapper mapper)
        {
            this.Mapper = mapper;
            this._context = _context;
            ClientFireBase = StartFireBase();
        }

        [HttpPost]
        [Authorize(Roles = "Teacher , Admin")]
        public async Task<IActionResult> CreateAnnouncement([FromBody] AnnouncementDto announcementDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            var announcement = Mapper.Map<AnnouncementDto,Announcement>(announcementDto);
            announcement.Timestamp =DateTime.Now.ToString();
            _context.Announcements.Add(announcement);
            await _context.SaveChangesAsync();

            announcement = await _context.Announcements.FindAsync(announcement.Id);
            var result = Mapper.Map<Announcement,AnnouncementDto>(announcement);

            var body = new
                {
                    notification = new
                    {
                        body = $"New Announcement: {announcement.caption}",
                        title = $"{announcement.DisplayName}"
                    },
                    priority = "high",
                    data = new
                    {
                        clickaction = "FLUTTERNOTIFICATIONCLICK",
                        id = "1",
                        status = "done"
                    },
                    to = "/topics/all"
                };

                ClientFireBase.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("key", "=AAAAV02ojhg:APA91bGng1U47tjWoEhKszz5FqOqxwSMGDy8XB5ILjWaKdpcdUBTxi4hHjbX_mV6UbVFsm4zr-CoA0Hzx0i2763ADlNnU5XuX578ObGjo1CEXlWvjlISev3_9Cpgtg_tNOBtqe6hhsqT");
                var response = await ClientFireBase.PostAsync("fcm/send", new StringContent(
                    JsonConvert.SerializeObject(body),
                    Encoding.UTF8, "application/json"));
                var retFireBase = await response.Content.ReadAsStringAsync();

            return Ok(result);
        }

        [HttpGet("{divId}")]
        public async Task<IEnumerable<AnnouncementDto>> GetAnnouncement(int divId)
        {
            var announcements = await _context.Announcements.Where(a => a.DivisionId == divId).OrderByDescending(a =>a.Timestamp).ToListAsync();
            
            return Mapper.Map<List<Announcement>,List<AnnouncementDto>>(announcements);
        }

        private HttpClient StartFireBase()
        {
            var client = new HttpClient();
            client.BaseAddress = new Uri("https://fcm.googleapis.com");
            return client;
        }

    }
}