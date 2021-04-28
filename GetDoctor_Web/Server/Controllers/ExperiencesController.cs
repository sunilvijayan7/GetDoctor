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
    public class ExperiencesController : ControllerBase
    {
        private readonly PatientdbContext _context;

        public ExperiencesController(PatientdbContext context)
        {
            _context = context;
        }

        // GET: api/Experiences
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Experience>>> GetExperience()
        {
            return await _context.Experience.ToListAsync();
        }

        // GET: api/Experiences/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Experience>> GetExperience(int id)
        {
            var experience = await _context.Experience.FindAsync(id);

            if (experience == null)
            {
                return NotFound();
            }

            return experience;
        }

        // PUT: api/Experiences/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutExperience(int id, Experience experience)
        {
            if (id != experience.ExperienceId)
            {
                return BadRequest();
            }

            _context.Entry(experience).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ExperienceExists(id))
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

        // POST: api/Experiences
        [HttpPost]
        public async Task<ActionResult<Experience>> PostExperience(Experience experience)
        {
            _context.Experience.Add(experience);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetExperience", new { id = experience.ExperienceId }, experience);
        }

        // DELETE: api/Experiences/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Experience>> DeleteExperience(int id)
        {
            var experience = await _context.Experience.FindAsync(id);
            if (experience == null)
            {
                return NotFound();
            }

            _context.Experience.Remove(experience);
            await _context.SaveChangesAsync();

            return experience;
        }

        private bool ExperienceExists(int id)
        {
            return _context.Experience.Any(e => e.ExperienceId == id);
        }
    }
}
