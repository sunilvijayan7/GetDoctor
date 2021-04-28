using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GetDoctor.Server;
using GetDoctor.Shared.Models;

namespace GetDoctor.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatientsController : ControllerBase
    {
        private readonly PatientdbContext _context;

        public PatientsController(PatientdbContext context)
        {
            _context = context;
        }

        // GET: api/Patients
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Patients>>> GetPatient()
        {

            return await _context.Patient.Include(m=>m.BloodGroup).Include(x=>x.Gender).ToListAsync();
        }

        // GET: api/Patients/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Patients>> GetPatients(int id)
        {
            var patients = await _context.Patient.FindAsync(id);

            if (patients == null)
            {
                return NotFound();
            }

            return patients;
        }

        // PUT: api/Patients/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPatients(int id, Patients patients)
        {
            if (id != patients.PatientsId)
            {
                return BadRequest();
            }

            _context.Entry(patients).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PatientsExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Patients
        [HttpPost]
        public async Task<ActionResult<Patients>> PostPatients(Patients patients)
        {
            _context.Patient.Add(patients);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPatients", new { id = patients.PatientsId }, patients);
        }

        // DELETE: api/Patients/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Patients>> DeletePatients(int id)
        {
            var patients = await _context.Patient.FindAsync(id);
            if (patients == null)
            {
                return NotFound();
            }

            _context.Patient.Remove(patients);
            await _context.SaveChangesAsync();

            return patients;
        }

        private bool PatientsExists(int id)
        {
            return _context.Patient.Any(e => e.PatientsId == id);
        }
    }
}
