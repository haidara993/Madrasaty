using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using madrasaty1.Data;
using madrasaty1.Dtos;
using madrasaty1.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace madrasaty1.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    public class AssignmentController : ControllerBase
    {
        public DataContext _context { get; set; }
        public IMapper Mapper { get; set; }
        public IWebHostEnvironment HostEnvironment { get; set; }
        public AssignmentController(DataContext context, IMapper mapper, IWebHostEnvironment hostEnvironment)
        {
            this.HostEnvironment = hostEnvironment;
            this.Mapper = mapper;
            _context = context;

        }

        [HttpPost]
        [Authorize(Roles = "Teacher , Admin")]
        public async Task<IActionResult> CreateAssignment([FromBody] AssignmentDto assignmentDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            var assignment = Mapper.Map<AssignmentDto,Assignment>(assignmentDto);
            assignment.Timestamp =DateTime.Now.ToString();
            _context.Assignments.Add(assignment);
            await _context.SaveChangesAsync();

            assignment = await _context.Assignments.FindAsync(assignment.Id);
            var result = Mapper.Map<Assignment,AssignmentDto>(assignment);
            return Ok(result);
        }

        [HttpGet("{divId}")]
        public async Task<IEnumerable<AssignmentDto>> GetAnnouncement(int divId)
        {
            var assignments = await _context.Assignments.Where(a => a.DivisionId == divId).OrderByDescending(a =>a.Timestamp).ToListAsync();
            
            return Mapper.Map<List<Assignment>,List<AssignmentDto>>(assignments);
        }

        
    }
}