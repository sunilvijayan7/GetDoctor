using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

namespace GetDoctor.Server.Migrations
{
    public partial class addAppointment : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Appointment",
                columns: table => new
                {
                    AppointmentId = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn),
                    PatientsId = table.Column<int>(nullable: false),
                    Day = table.Column<string>(nullable: true),
                    DepartmentsId = table.Column<int>(nullable: false),
                    DoctorsId = table.Column<int>(nullable: false),
                    Symptoms = table.Column<string>(nullable: true),
                    IsVisible = table.Column<bool>(nullable: false),
                    Urd = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Appointment", x => x.AppointmentId);
                    table.ForeignKey(
                        name: "FK_Appointment_Department_DepartmentsId",
                        column: x => x.DepartmentsId,
                        principalTable: "Department",
                        principalColumn: "DepartmentsId",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_Appointment_Doctor_DoctorsId",
                        column: x => x.DoctorsId,
                        principalTable: "Doctor",
                        principalColumn: "DoctorsId",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_Appointment_Patient_PatientsId",
                        column: x => x.PatientsId,
                        principalTable: "Patient",
                        principalColumn: "PatientsId",
                        onDelete: ReferentialAction.NoAction);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Appointment_DepartmentsId",
                table: "Appointment",
                column: "DepartmentsId");

            migrationBuilder.CreateIndex(
                name: "IX_Appointment_DoctorsId",
                table: "Appointment",
                column: "DoctorsId");

            migrationBuilder.CreateIndex(
                name: "IX_Appointment_PatientsId",
                table: "Appointment",
                column: "PatientsId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Appointment");
        }
    }
}
