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
    public class DoctorsController : ControllerBase
    {
        private readonly PatientdbContext _context;

        public DoctorsController(PatientdbContext context)
        {
            _context = context;
        }

        // GET: api/Doctors
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Doctors>>> GetDoctor()
        {
            return await _context.Doctor.Include(G=>G.Gender)
                .Include(exper=>exper.Experience)
                .Include(depart=>depart.Department)
                .ToListAsync();
        }

        // GET: api/Doctors/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Doctors>> GetDoctors(int id)
        {
            var doctors = await _context.Doctor.FindAsync(id);

            if (doctors == null)
            {
                return NotFound();
            }

            return doctors;
        }

        // PUT: api/Doctors/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDoctors(int id, Doctors doctors)
        {
            if (id != doctors.DoctorsId)
            {
                return BadRequest();
            }

            _context.Entry(doctors).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DoctorsExists(id))
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

        // POST: api/Doctors
        [HttpPost]
        public async Task<ActionResult<Doctors>> PostDoctors(Doctors doctors)
        {
            _context.Doctor.Add(doctors);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetDoctors", new { id = doctors.DoctorsId }, doctors);
        }

        // DELETE: api/Doctors/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Doctors>> DeleteDoctors(int id)
        {
            var doctors = await _context.Doctor.FindAsync(id);
            if (doctors == null)
            {
                return NotFound();
            }

            _context.Doctor.Remove(doctors);
            await _context.SaveChangesAsync();

            return doctors;
        }

        private bool DoctorsExists(int id)
        {
            return _context.Doctor.Any(e => e.DoctorsId == id);
        }
    }
}
