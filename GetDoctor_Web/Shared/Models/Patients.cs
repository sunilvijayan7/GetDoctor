using System;
using System.Collections.Generic;
using System.Text;

namespace GetDoctor.Shared.Models
{
  public  class Patients
    {
        public int PatientsId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Symptoms { get; set; }
        public string Birthday { get; set; }
        public int BloodGroupsId { get; set; }
        public BloodGroups BloodGroup { get; set; }
        public int GendersId { get; set; }
        public Genders Gender { get; set; }
        public bool IsVisible { get; set; } 
        public string Urd { get; set; }
    }
}
