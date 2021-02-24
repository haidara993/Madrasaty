using Microsoft.EntityFrameworkCore;
using madrasaty1.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Identity;
using madrasaty1.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using AutoMapper;
using madrasaty1.Helpers;

namespace madrasaty
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers(options => options.SuppressAsyncSuffixInActionNames = false);
            services.AddDbContext<DataContext>(x => {
                x.UseSqlServer(Configuration.GetConnectionString("DefualtConnection"));
            });

            IdentityBuilder builder = services.AddIdentityCore<User>(opt =>{
                opt.Password.RequireDigit=false;
                opt.Password.RequiredLength=4;
                opt.Password.RequireNonAlphanumeric=false;
                opt.Password.RequireUppercase=false;
            });

            builder = new IdentityBuilder(builder.UserType,typeof(Role), builder.Services);
            builder.AddEntityFrameworkStores<DataContext>();
            builder.AddRoleValidator<RoleValidator<Role>>();
            builder.AddRoleManager<RoleManager<Role>>();
            builder.AddSignInManager<SignInManager<User>>();
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(option =>{
                option.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey =true,
                    IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.ASCII
                    .GetBytes(Configuration.GetSection("AppSettings:Token").Value)),
                    ValidateIssuer =false,
                    ValidateAudience = false
                };
            });
            
            services.AddMvc(option =>{
                var policy = new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build();
                option.Filters.Add(new AuthorizeFilter(policy));
            }).AddJsonOptions(opt => {
                    opt.JsonSerializerOptions.IgnoreReadOnlyProperties = 
                        true;
                });
            services.AddCors();
            var mapperConfig = new MapperConfiguration(mc =>
            {
                mc.AddProfile(new AutoMappingProfile());
            });

            IMapper mapper = mapperConfig.CreateMapper();
            services.AddSingleton(mapper);
        
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();
            
            app.UseStaticFiles();

            app.UseCors(x => x.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
            
            app.UseAuthentication();

            app.UseAuthorization(); 

             
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
