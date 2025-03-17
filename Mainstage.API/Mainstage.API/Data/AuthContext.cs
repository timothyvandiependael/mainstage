using Microsoft.EntityFrameworkCore;
using Mainstage.API.Models;

namespace Mainstage.API.Data
{
    public class AuthContext : DbContext
    {
        public AuthContext(DbContextOptions<AuthContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<TempUser> TempUsers { get; set; }
        public DbSet<RefreshToken> RefreshTokens { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<RefreshToken>().HasKey(r => r.UserId);
            base.OnModelCreating(modelBuilder);
        }
    }
}
