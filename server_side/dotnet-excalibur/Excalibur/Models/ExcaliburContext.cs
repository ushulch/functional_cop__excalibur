using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace Excalibur.Models
{
    public partial class ExcaliburContext : DbContext
    {
        public ExcaliburContext()
        {
        }

        public ExcaliburContext(DbContextOptions<ExcaliburContext> options)
            : base(options)
        {
        }


        public virtual DbSet<Transaction> Transactions { get; set; }



        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseNpgsql("Host=localhost;Database=excalibur;Username=excalibur;Password=Starkle5!");
            }
        }



        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.6-servicing-10079");

            modelBuilder.Entity<Transaction>(entity =>
                    {
                        entity.ToTable("transactions");

                        entity.Property(e => e.Id)
                        .HasColumnName("id")
                        .ValueGeneratedNever();

                        entity.Property(e => e.Amount)
                        .HasColumnName("amount")
                        .HasColumnType("money");

                        entity.Property(e => e.Date)
                        .HasColumnName("date")
                        .HasColumnType("date");

                        entity.Property(e => e.Vendor)
                        .IsRequired()
                        .HasColumnName("vendor")
                        .HasColumnType("character varying");
                    });
        }
    }
}
