using System;
using System.Collections.Generic;
using System.Text;

namespace GetDoctor.Shared.Models
{
   public class Departments
    {
        public int DepartmentsId { get; set; }
        public string Name { get; set; }
        public bool IsVisible { get; set; } 
        public string Urd { get; set; }
    }
}
