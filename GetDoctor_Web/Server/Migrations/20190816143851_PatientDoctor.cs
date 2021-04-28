using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

namespace GetDoctor.Server.Migrations
{
    public partial class PatientDoctor : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BloodGroup",
                columns: table => new
                {
                    BloodGroupsId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    Name = table.Column<string>(nullable: true),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BloodGroup", x => x.BloodGroupsId);
                });

            migrationBuilder.CreateTable(
                name: "Department",
                columns: table => new
                {
                    DepartmentsId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    Name = table.Column<string>(nullable: true),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Department", x => x.DepartmentsId);
                });

            migrationBuilder.CreateTable(
                name: "Experience",
                columns: table => new
                {
                    ExperienceId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    Name = table.Column<string>(nullable: true),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Experience", x => x.ExperienceId);
                });

            migrationBuilder.CreateTable(
                name: "Gender",
                columns: table => new
                {
                    GendersId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    Name = table.Column<string>(nullable: true),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Gender", x => x.GendersId);
                });

            migrationBuilder.CreateTable(
                name: "Doctor",
                columns: table => new
                {
                    DoctorsId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    FirstName = table.Column<string>(nullable: true),
                    LastName = table.Column<string>(nullable: true),
                    PhoneNumber = table.Column<string>(nullable: true),
                    Email = table.Column<string>(nullable: true),
                    Education = table.Column<string>(nullable: true),
                    Designation = table.Column<string>(nullable: true),
                    GendersId = table.Column<int>(nullable: false),
                    ExperienceId = table.Column<int>(nullable: false),
                    DepartmentsId = table.Column<int>(nullable: false),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Doctor", x => x.DoctorsId);
                    table.ForeignKey(
                        name: "FK_Doctor_Department_DepartmentsId",
                        column: x => x.DepartmentsId,
                        principalTable: "Department",
                        principalColumn: "DepartmentsId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Doctor_Experience_ExperienceId",
                        column: x => x.ExperienceId,
                        principalTable: "Experience",
                        principalColumn: "ExperienceId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Doctor_Gender_GendersId",
                        column: x => x.GendersId,
                        principalTable: "Gender",
                        principalColumn: "GendersId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Patient",
                columns: table => new
                {
                    PatientsId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    FirstName = table.Column<string>(nullable: true),
                    LastName = table.Column<string>(nullable: true),
                    PhoneNumber = table.Column<string>(nullable: true),
                    Email = table.Column<string>(nullable: true),
                    Symptoms = table.Column<string>(nullable: true),
                    Birthday = table.Column<string>(nullable: true),
                    BloodGroupsId = table.Column<int>(nullable: false),
                    GendersId = table.Column<int>(nullable: false),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Patient", x => x.PatientsId);
                    table.ForeignKey(
                        name: "FK_Patient_BloodGroup_BloodGroupsId",
                        column: x => x.BloodGroupsId,
                        principalTable: "BloodGroup",
                        principalColumn: "BloodGroupsId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Patient_Gender_GendersId",
                        column: x => x.GendersId,
                        principalTable: "Gender",
                        principalColumn: "GendersId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Doctor_DepartmentsId",
                table: "Doctor",
                column: "DepartmentsId");

            migrationBuilder.CreateIndex(
                name: "IX_Doctor_ExperienceId",
                table: "Doctor",
                column: "ExperienceId");

            migrationBuilder.CreateIndex(
                name: "IX_Doctor_GendersId",
                table: "Doctor",
                column: "GendersId");

            migrationBuilder.CreateIndex(
                name: "IX_Patient_BloodGroupsId",
                table: "Patient",
                column: "BloodGroupsId");

            migrationBuilder.CreateIndex(
                name: "IX_Patient_GendersId",
                table: "Patient",
                column: "GendersId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Doctor");

            migrationBuilder.DropTable(
                name: "Patient");

            migrationBuilder.DropTable(
                name: "Department");

            migrationBuilder.DropTable(
                name: "Experience");

            migrationBuilder.DropTable(
                name: "BloodGroup");

            migrationBuilder.DropTable(
                name: "Gender");
        }
    }
}
