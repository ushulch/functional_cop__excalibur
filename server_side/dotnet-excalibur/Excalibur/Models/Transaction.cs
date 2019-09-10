using System;
using System.Collections.Generic;

namespace Excalibur.Models
{
    public partial class Transaction
    {
        public Guid Id { get; set; }
        public DateTime Date { get; set; }
        public string Vendor { get; set; }
        public decimal Amount { get; set; }
    }
}
