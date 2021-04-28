using GetDoctor.Shared.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GetDoctor.Server
{
    public class PatientdbContext : DbContext
    {
        public PatientdbContext(DbContextOptions<PatientdbContext> options) : base(options)
        {

        }

        public DbSet<Experience> Experience { get; set; }
        public DbSet<BloodGroups> BloodGroup { get; set; }
        public DbSet<Departments> Department { get; set; }
        public DbSet<Genders> Gender { get; set; }
        public DbSet<Patients> Patient { get; set; }
        public DbSet<Doctors> Doctor { get; set; }
        public DbSet<Appointment> Appointment { get; set; }
        

    }
}
