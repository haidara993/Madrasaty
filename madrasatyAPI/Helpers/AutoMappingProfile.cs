using AutoMapper;
using madrasaty1.Models;
using madrasaty1.Dtos;

namespace madrasaty1.Helpers
{
    public class AutoMappingProfile:Profile
    {
        public AutoMappingProfile()
        {
            
            CreateMap<UserForRegisterDto, User>();
            CreateMap<UserForUpdateDto, User>();
            CreateMap<AnnouncementDto, Announcement>()
            .ForMember(a =>a.Id,opt =>opt.Ignore());
            CreateMap<AssignmentDto, Assignment>()
            .ForMember(a =>a.Id,opt =>opt.Ignore());

            CreateMap<User,UserForListDto>()
            .ForMember(ud =>ud.Division,opt =>opt.MapFrom(u =>u.Division.DivisionName))
            .ForMember(ud =>ud.Standard,opt =>opt.MapFrom(u =>u.Standard.StandardName));
            CreateMap<User,UserForUpdateDto>();
            CreateMap<User,UserForReadDto>();
            CreateMap<Announcement,AnnouncementDto>();
            CreateMap<Assignment,AssignmentDto>();
        }
    }
}