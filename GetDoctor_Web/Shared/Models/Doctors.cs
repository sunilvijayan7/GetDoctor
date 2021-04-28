using System;
using System.Collections.Generic;
using System.Text;

namespace GetDoctor.Shared.Models
{
   public class Doctors
    {
        public int DoctorsId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Education { get; set; }
        public string Designation { get; set; }
        public int GendersId { get; set; }
        public Genders Gender { get; set; }
        public int ExperienceId { get; set; }
        public Experience Experience { get; set; }
        public int DepartmentsId { get; set; }
        public Departments Department { get; set; }
        //public string DutyTiming { get; set; }
        public bool IsVisible { get; set; } = true;
        public string Urd { get; set; }
    }

}
