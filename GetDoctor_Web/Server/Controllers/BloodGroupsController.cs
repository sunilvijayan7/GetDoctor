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
    public class BloodGroupsController : ControllerBase
    {
        private readonly PatientdbContext _context;

        public BloodGroupsController(PatientdbContext context)
        {
            _context = context;
        }

        // GET: api/BloodGroups
        [HttpGet]
        public async Task<ActionResult<IEnumerable<BloodGroups>>> GetBloodGroup()
        {
            return await _context.BloodGroup.ToListAsync();
        }

        // GET: api/BloodGroups/5
        [HttpGet("{id}")]
        public async Task<ActionResult<BloodGroups>> GetBloodGroups(int id)
        {
            var bloodGroups = await _context.BloodGroup.FindAsync(id);

            if (bloodGroups == null)
            {
                return NotFound();
            }

            return bloodGroups;
        }

        // PUT: api/BloodGroups/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutBloodGroups(int id, BloodGroups bloodGroups)
        {
            if (id != bloodGroups.BloodGroupsId)
            {
                return BadRequest();
            }

            _context.Entry(bloodGroups).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!BloodGroupsExists(id))
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

        // POST: api/BloodGroups
        [HttpPost]
        public async Task<ActionResult<BloodGroups>> PostBloodGroups(BloodGroups bloodGroups)
        {
            _context.BloodGroup.Add(bloodGroups);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetBloodGroups", new { id = bloodGroups.BloodGroupsId }, bloodGroups);
        }

        // DELETE: api/BloodGroups/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<BloodGroups>> DeleteBloodGroups(int id)
        {
            var bloodGroups = await _context.BloodGroup.FindAsync(id);
            if (bloodGroups == null)
            {
                return NotFound();
            }

            _context.BloodGroup.Remove(bloodGroups);
            await _context.SaveChangesAsync();

            return bloodGroups;
        }

        private bool BloodGroupsExists(int id)
        {
            return _context.BloodGroup.Any(e => e.BloodGroupsId == id);
        }
    }
}
