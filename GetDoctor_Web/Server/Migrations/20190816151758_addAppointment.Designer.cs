﻿// <auto-generated />
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using GetDoctor.Server;

namespace GetDoctor.Server.Migrations
{
    [DbContext(typeof(PatientdbContext))]
    [Migration("20190816151758_addAppointment")]
    partial class addAppointment
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "3.0.0-preview8.19405.11")
                .HasAnnotation("Relational:MaxIdentifierLength", 128)
                .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

            modelBuilder.Entity("GetDoctor.Shared.Models.Appointment", b =>
                {
                    b.Property<int>("AppointmentId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("Day")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("DepartmentsId")
                        .HasColumnType("int");

                    b.Property<int>("DoctorsId")
                        .HasColumnType("int");

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<int>("PatientsId")
                        .HasColumnType("int");

                    b.Property<string>("Symptoms")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("AppointmentId");

                    b.HasIndex("DepartmentsId");

                    b.HasIndex("DoctorsId");

                    b.HasIndex("PatientsId");

                    b.ToTable("Appointment");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.BloodGroups", b =>
                {
                    b.Property<int>("BloodGroupsId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("BloodGroupsId");

                    b.ToTable("BloodGroup");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Departments", b =>
                {
                    b.Property<int>("DepartmentsId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("DepartmentsId");

                    b.ToTable("Department");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Doctors", b =>
                {
                    b.Property<int>("DoctorsId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("DepartmentsId")
                        .HasColumnType("int");

                    b.Property<string>("Designation")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Education")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("ExperienceId")
                        .HasColumnType("int");

                    b.Property<string>("FirstName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("GendersId")
                        .HasColumnType("int");

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<string>("LastName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("DoctorsId");

                    b.HasIndex("DepartmentsId");

                    b.HasIndex("ExperienceId");

                    b.HasIndex("GendersId");

                    b.ToTable("Doctor");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Experience", b =>
                {
                    b.Property<int>("ExperienceId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("ExperienceId");

                    b.ToTable("Experience");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Genders", b =>
                {
                    b.Property<int>("GendersId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("GendersId");

                    b.ToTable("Gender");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Patients", b =>
                {
                    b.Property<int>("PatientsId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("Birthday")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("BloodGroupsId")
                        .HasColumnType("int");

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("GendersId")
                        .HasColumnType("int");

                    b.Property<bool>("IsVisible")
                        .HasColumnType("bit");

                    b.Property<string>("LastName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Symptoms")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Urd")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("PatientsId");

                    b.HasIndex("BloodGroupsId");

                    b.HasIndex("GendersId");

                    b.ToTable("Patient");
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Appointment", b =>
                {
                    b.HasOne("GetDoctor.Shared.Models.Departments", "Departments")
                        .WithMany()
                        .HasForeignKey("DepartmentsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GetDoctor.Shared.Models.Doctors", "Doctors")
                        .WithMany()
                        .HasForeignKey("DoctorsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GetDoctor.Shared.Models.Patients", "Patients")
                        .WithMany()
                        .HasForeignKey("PatientsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Doctors", b =>
                {
                    b.HasOne("GetDoctor.Shared.Models.Departments", "Department")
                        .WithMany()
                        .HasForeignKey("DepartmentsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GetDoctor.Shared.Models.Experience", "Experience")
                        .WithMany()
                        .HasForeignKey("ExperienceId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GetDoctor.Shared.Models.Genders", "Gender")
                        .WithMany()
                        .HasForeignKey("GendersId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("GetDoctor.Shared.Models.Patients", b =>
                {
                    b.HasOne("GetDoctor.Shared.Models.BloodGroups", "BloodGroup")
                        .WithMany()
                        .HasForeignKey("BloodGroupsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GetDoctor.Shared.Models.Genders", "Gender")
                        .WithMany()
                        .HasForeignKey("GendersId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });
#pragma warning restore 612, 618
        }
    }
}
