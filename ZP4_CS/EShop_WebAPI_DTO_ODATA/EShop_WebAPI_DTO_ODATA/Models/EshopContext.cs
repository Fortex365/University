using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace EShop_WebAPI_DTO_ODATA.Models
{
    public class EshopContext : DbContext
    {
        public EshopContext() : base("EshopConnection")
        {

        }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<PrizeAtThatTime> Histories { get; set; }

        protected override void OnModelCreating(DbModelBuilder mb)
        {
            mb.Entity<Customer>().Property(i => i.Surname).IsRequired().HasMaxLength(100);
            mb.Entity<Product>().Property(i => i.ProductName).IsRequired().HasMaxLength(100);
            mb.Entity<PrizeAtThatTime>().Property(i => i.Prize).IsRequired();
            mb.Entity<PrizeAtThatTime>().Property(i => i.Date).IsRequired();
        }
    }
}