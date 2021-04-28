using System;
using System.Collections.Generic;
//using System.ComponentModel.DataAnnotations;
using System.Text;

namespace GetDoctor.Shared.Models
{
   public class BloodGroups
    {
        
        public int BloodGroupsId { get; set; }
        public string Name { get; set; }
        public bool IsVisible { get; set; }
        public string Urd { get; set; }
    }
}
