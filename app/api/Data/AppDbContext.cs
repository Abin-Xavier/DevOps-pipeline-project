using Microsoft.EntityFrameworkCore;
using TaskApi.Models;

namespace TaskApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<TaskItem> Tasks => Set<TaskItem>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TaskItem>().Property(t => t.Title).IsRequired().HasMaxLength(200);

        modelBuilder.Entity<TaskItem>().HasData(
            new TaskItem { Id = 1, Title = "Set up the repo", Done = true },
            new TaskItem { Id = 2, Title = "Dockerize the API", Done = false });
    }
}
