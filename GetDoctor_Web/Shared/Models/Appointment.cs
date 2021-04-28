using System;
using System.Collections.Generic;
using System.Text;

namespace GetDoctor.Shared.Models
{
   public class Appointment
    {
        public int AppointmentId { get; set; }
        public int PatientsId { get; set; }
        public Patients Patients { get; set; }
        public string Day { get; set; }
        public int DepartmentsId { get; set; }
        public Departments Departments { get; set; }

        public int DoctorsId { get; set; }
        public Doctors Doctors { get; set; }
        public string Symptoms { get; set; }

        public bool IsVisible { get; set; }
        public string Urd { get; set; }


    }
}
