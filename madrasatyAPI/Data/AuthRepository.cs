using System.Threading.Tasks;
using madrasaty1.Data;
using madrasaty1.Models;
using Microsoft.EntityFrameworkCore;

namespace madrasaty1.Data
{
    public class AuthRepository : IAuthRepository
    {
        public DataContext Context { get; set; }
        public AuthRepository(DataContext context)
        {
            this.Context = context;

        }
        public async Task<User> Login(string username, string password)
        {

            var user = await Context.Users.FirstOrDefaultAsync(x => x.UserName == username);

            if (user == null)
                return null;

            // if (!VerifyPasswordHash(password, user.PasswordHash, user.PasswordSalt))
            //     return null;

            return user;
        }

        public async Task<User> Register(User user, string password)
        {
            byte[] passwordHash, passwordSalt;
            CreatePasswordHash(password, out passwordHash, out passwordSalt);

            // user.PasswordHash = passwordHash;
            // user.PasswordSalt = passwordSalt;

            await Context.Users.AddAsync(user);

            await Context.SaveChangesAsync();

            return user;
        }

        private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            using (var hmac = new System.Security.Cryptography.HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            } 
        }

        public async Task<bool> UserExists(string username)
        {
            if (await Context.Users.AnyAsync(x => x.UserName == username))
                return true;

            return false;
        }
    }
}