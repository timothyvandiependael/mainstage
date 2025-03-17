using Microsoft.EntityFrameworkCore;
using Mainstage.API.Models;
using Microsoft.Extensions.Configuration;

namespace Mainstage.API.Data
{
    public class MainstageContext : DbContext
    {
        public MainstageContext(DbContextOptions<MainstageContext> options) : base(options) { }

        public DbSet<Card> Cards { get; set; }
        public DbSet<Game> Games { get; set; }
        public DbSet<GameAction> GameActions { get; set; }
        public DbSet<GameCard> GameCards { get; set; }
        public DbSet<GamePlayer> GamePlayers { get; set; }
        public DbSet<GamePlayerCard> GamePlayerCards { get; set; }
        public DbSet<Player> Players { get; set; }
        public DbSet<Tile> Tiles { get; set; }
        public DbSet<ChatMessage> ChatMessages { get; set; }
        public DbSet<GameOptions> GameOptions { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Game>()
                .Property(e => e.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<GameAction>()
                .HasKey(o => new { o.GameId, o.PlayerId, o.ActionId });
            modelBuilder.Entity<GameCard>()
                .HasKey(o => new { o.GameId, o.CardId });
            modelBuilder.Entity<GamePlayer>()
                .HasKey(o => new { o.GameId, o.PlayerId });
            modelBuilder.Entity<GamePlayerCard>()
                .HasKey(o => new { o.GameId, o.PlayerId, o.CardId });
            modelBuilder.Entity<ChatMessage>()
                .HasKey(o => new { o.ChatId, o.PlayerId, o.MessageId });
            modelBuilder.Entity<GameOptions>()
                .HasKey(o => new { o.GameId });
            modelBuilder.Entity<ChatMessage>()
                .Property(e => e.MessageId).ValueGeneratedOnAdd();

        }
    }
}
