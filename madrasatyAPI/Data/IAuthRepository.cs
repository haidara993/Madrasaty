using System.Threading.Tasks;
using madrasaty1.Models;

namespace madrasaty1.Data
{
    public interface IAuthRepository
    {
         Task<User> Register(User user,string password);
         Task<User> Login(string username, string password);
         Task<bool> UserExists(string username);
    }
}