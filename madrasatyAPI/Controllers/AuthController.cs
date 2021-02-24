using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using madrasaty1.Models;
using madrasaty1.Data;
using madrasaty1.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace madrasaty1.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        public IConfiguration Configuration { get; set; }
        public IMapper Mapper { get; set; }
        public UserManager<User> UserManager { get; set; }
        public SignInManager<User> SignInManager { get; set; }
        public DataContext Context { get; set; }
        public AuthController(IConfiguration configuration, IMapper mapper, UserManager<User> userManager, SignInManager<User> signInManager, DataContext context)
        {
            this.Context = context;
            this.SignInManager = signInManager;
            this.UserManager = userManager;
            this.Mapper = mapper;
            this.Configuration = configuration;

        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserForLoginDto userForLoginDto)
        {

            var user = await UserManager.FindByNameAsync(userForLoginDto.Username);

            if (user == null)
            {
                return Unauthorized();
            }

            var result = await SignInManager
                .CheckPasswordSignInAsync(user, userForLoginDto.Password, false);

            if (result.Succeeded)
            {
                var appUser = await UserManager.Users.Include(u =>u.Division).Include(u =>u.Standard)
                    .FirstOrDefaultAsync(u => u.NormalizedUserName == userForLoginDto.Username.ToUpper());
                var userToReturn = Mapper.Map<UserForListDto>(appUser);
                // var resutl = new
                // {
                //     token = GenerateJwtToken(appUser).Result,
                //     user = userToReturn
                // };
                userToReturn.jwt = GenerateJwtToken(appUser).Result;
                return Ok(userToReturn);

                // return Ok(GenerateJwtToken(appUser).Result);                 
            }
            return Unauthorized();

        }

        private async Task<string> GenerateJwtToken(User user)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.UserName)
            };

            var roles = await UserManager.GetRolesAsync(user);

            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            var key = new SymmetricSecurityKey(Encoding.UTF8
                .GetBytes(Configuration.GetSection("AppSettings:Token").Value));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(1),
                SigningCredentials = creds
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] UserForRegisterDto userForRegisterDto)
        {
            // userForRegisterDto.UserName = userForRegisterDto.UserName.ToLower();

            // if (await Repo.UserExists(userForRegisterDto.UserName))
            //     return BadRequest("Username already exists");
            var userToCreate = Mapper.Map<UserForRegisterDto, User>(userForRegisterDto);

            var result = await UserManager.CreateAsync(userToCreate, userForRegisterDto.Password);


            var userToReturn = Mapper.Map<UserForListDto>(userToCreate);

            if (result.Succeeded)
            {
                var user = UserManager.FindByNameAsync(userForRegisterDto.UserName).Result;
                UserManager.AddToRolesAsync(user, new[] { "Teacher" }).Wait();
                return Ok();
            }

            return BadRequest(result.Errors);

        }

        [HttpPut("update/{id}")]
        [Authorize]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] UserForUpdateDto userForUpdateDto)
        {
            if(!ModelState.IsValid){
                return BadRequest();
            }
            var user = await Context.Users.Include(u =>u.Division).Include(u =>u.Standard).FirstOrDefaultAsync(u =>u.Id == id);
            if(user == null){
                return NotFound();
            }
            Mapper.Map<UserForUpdateDto,User>(userForUpdateDto,user);
            await Context.SaveChangesAsync();

            user = await Context.Users.FindAsync(user.Id);
            var result = Mapper.Map<User,UserForListDto>(user);
            return Ok(result);

        }

        [HttpGet("get/{id}")]
        [Authorize]
        public async Task<IActionResult> GetUser(int id){
            var user = await Context.Users.Include(u =>u.Division).Include(u =>u.Standard).FirstOrDefaultAsync(u =>u.Id == id);
            if(user == null){
                return NotFound();
            }
            var usertoreturn = Mapper.Map<User,UserForListDto>(user);
            return Ok(usertoreturn);
        }



    }
}