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
    public class GendersController : ControllerBase
    {
        private readonly PatientdbContext _context;

        public GendersController(PatientdbContext context)
        {
            _context = context;
        }

        // GET: api/Genders
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Genders>>> GetGender()
        {
            return await _context.Gender.ToListAsync();
        }

        // GET: api/Genders/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Genders>> GetGenders(int id)
        {
            var genders = await _context.Gender.FindAsync(id);

            if (genders == null)
            {
                return NotFound();
            }

            return genders;
        }

        // PUT: api/Genders/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutGenders(int id, Genders genders)
        {
            if (id != genders.GendersId)
            {
                return BadRequest();
            }

            _context.Entry(genders).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!GendersExists(id))
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

        // POST: api/Genders
        [HttpPost]
        public async Task<ActionResult<Genders>> PostGenders(Genders genders)
        {
            _context.Gender.Add(genders);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetGenders", new { id = genders.GendersId }, genders);
        }

        // DELETE: api/Genders/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Genders>> DeleteGenders(int id)
        {
            var genders = await _context.Gender.FindAsync(id);
            if (genders == null)
            {
                return NotFound();
            }

            _context.Gender.Remove(genders);
            await _context.SaveChangesAsync();

            return genders;
        }

        private bool GendersExists(int id)
        {
            return _context.Gender.Any(e => e.GendersId == id);
        }
    }
}
