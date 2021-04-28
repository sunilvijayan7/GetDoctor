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
    public class DepartmentsController : ControllerBase
    {
        private readonly PatientdbContext _context;

        public DepartmentsController(PatientdbContext context)
        {
            _context = context;
        }

        // GET: api/Departments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Departments>>> GetDepartment()
        {
            return await _context.Department.ToListAsync();
        }

        // GET: api/Departments/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Departments>> GetDepartments(int id)
        {
            var departments = await _context.Department.FindAsync(id);

            if (departments == null)
            {
                return NotFound();
            }

            return departments;
        }

        // PUT: api/Departments/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDepartments(int id, Departments departments)
        {
            if (id != departments.DepartmentsId)
            {
                return BadRequest();
            }

            _context.Entry(departments).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DepartmentsExists(id))
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

        // POST: api/Departments
        [HttpPost]
        public async Task<ActionResult<Departments>> PostDepartments(Departments departments)
        {
            _context.Department.Add(departments);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetDepartments", new { id = departments.DepartmentsId }, departments);
        }

        // DELETE: api/Departments/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Departments>> DeleteDepartments(int id)
        {
            var departments = await _context.Department.FindAsync(id);
            if (departments == null)
            {
                return NotFound();
            }

            _context.Department.Remove(departments);
            await _context.SaveChangesAsync();

            return departments;
        }

        private bool DepartmentsExists(int id)
        {
            return _context.Department.Any(e => e.DepartmentsId == id);
        }
    }
}
