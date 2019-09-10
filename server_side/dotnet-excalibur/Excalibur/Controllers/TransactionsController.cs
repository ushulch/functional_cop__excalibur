using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Excalibur.Models;
using Microsoft.EntityFrameworkCore;



namespace Excalibur.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TransactionsController : Controller
    {
        private readonly ExcaliburContext _context;

        public TransactionsController(ExcaliburContext context)
        {
            _context = context;
        }

        // GET: /api/transactions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Transaction>>> getTransactions()
        {
            return await _context.Transactions.ToListAsync();
        }


        // GET: /api/transactions/b6df5836-a643-44c2-86ee-78e0113f5e80
        [HttpGet("{id}")]
        public async Task<ActionResult<Transaction>> getTransaction(Guid id)
        {
            var transaction = await _context.Transactions.FindAsync(id);

            if(transaction == null)
            {
                return NotFound();
            }

            return transaction;
        }
    }
}
