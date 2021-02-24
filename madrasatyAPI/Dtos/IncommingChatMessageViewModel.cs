using madrasaty1.Models;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace madrasaty1.Dtos
{
    public class IncommingChatMessageViewModel
    {
        public string Message { get; set; }
        public User From { get; set; }
        public User To { get; set; }
        // public List<IFormFile> Attachments { get; set; }
        // public string Type { get; set; }
        // public bool IsTypeSet => !String.IsNullOrWhiteSpace(Type);
        // public IFormFile Video { get; set; }
    }
}
