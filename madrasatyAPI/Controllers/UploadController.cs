using System;
using System.IO;
using System.Threading.Tasks;
using madrasaty1.Data;
using madrasaty1.Dtos;
using madrasaty1.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace madrasaty1.Controllers
{
    [Route("api/[controller]")]
    [AllowAnonymous]
    public class UploadController : ControllerBase
    {
        public IWebHostEnvironment HostEnvironment { get; set; }
        public DataContext Context { get; set; }
        public UploadController(IWebHostEnvironment hostEnvironment, DataContext context)
        {
            this.Context = context;
            this.HostEnvironment = hostEnvironment;

        }

        [HttpPost("user/{id}")]
        public async Task<IActionResult> UploadImage(int id, IFormFile file)
        {

            var user = await Context.Users.FindAsync(id);
            if(user == null){
                return NotFound();
            }

            if (file == null) 
                return BadRequest("Null file");
            if (file.Length == 0) 
                return BadRequest("Empty file");

            string uniqueFileName = null;

            if (file != null)
            {
                string uploadsFolder = Path.Combine(HostEnvironment.WebRootPath, "images");
                uniqueFileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    file.CopyTo(fileStream);
                }
                user.PhotoUrl = "http://10.0.2.2:5000/images/"+ uniqueFileName;
                await Context.SaveChangesAsync();

            }
            return new ObjectResult(user.PhotoUrl);
        }

        [HttpPost("announcement")]
        [AllowAnonymous]
        public async Task<IActionResult> PostAnnouncementImage( IFormFile file){
            if (file == null) 
                return BadRequest("Null file");
            if (file.Length == 0) 
                return BadRequest("Empty file");

            string uniqueFileName = null;

            if (file != null)
            {
                string uploadsFolder = Path.Combine(HostEnvironment.WebRootPath, "images");
                uniqueFileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    file.CopyTo(fileStream);
                }

            }
            var result= "http://10.0.2.2:5000/images/"+ uniqueFileName;
            
            return new ObjectResult(result);

        }


        [HttpPost("assignment")]
        [AllowAnonymous]
        public async Task<IActionResult> PostAssignmentImage( IFormFile file){
            if (file == null) 
                return BadRequest("Null file");
            if (file.Length == 0) 
                return BadRequest("Empty file");

            string uniqueFileName = null;

            if (file != null)
            {
                string uploadsFolder = Path.Combine(HostEnvironment.WebRootPath, "assignments");
                uniqueFileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    file.CopyTo(fileStream);
                }

            }
            var result= "http://10.0.2.2:5000/assignments/"+ uniqueFileName;
            
            return new ObjectResult(result);

        }


        [HttpGet("user/{id}")]
        public async Task<IActionResult> GetPhoto(int id){
            var user = await Context.Users.FindAsync(id);
            if(user == null){
                return NotFound();
            }
            var path = Path.GetFullPath("./wwwroot/images/" + user.PhotoUrl);
            MemoryStream memory = new MemoryStream();
            using (FileStream stream = new FileStream(path, FileMode.Open))
            {
                await stream.CopyToAsync(memory);
            }
            memory.Position = 0;
            return File(memory, "image/png", Path.GetFileName(path));
        }
    }
}