using Microsoft.EntityFrameworkCore;
using TaskApi.Data;
using TaskApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Connection string comes from configuration (environment variable in Docker).
// The fallback is only a placeholder with no secret, used by the EF tooling.
var connectionString = builder.Configuration.GetConnectionString("Default")
    ?? "Server=localhost;Database=TaskDb;TrustServerCertificate=True";

builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddCors(options =>
    options.AddPolicy("frontend", policy =>
        policy.WithOrigins("http://localhost:4200")
              .AllowAnyHeader()
              .AllowAnyMethod()));

var app = builder.Build();
app.UseCors("frontend");

// Create or update the database tables at startup
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
}

app.MapGet("/health", () => Results.Ok(new { status = "Healthy" }));

app.MapGet("/api/tasks", async (AppDbContext db) =>
    await db.Tasks.OrderBy(t => t.Id).ToListAsync());

app.MapPost("/api/tasks", async (NewTask input, AppDbContext db) =>
{
    var task = new TaskItem { Title = input.Title, Done = false };
    db.Tasks.Add(task);
    await db.SaveChangesAsync();
    return Results.Created($"/api/tasks/{task.Id}", task);
});

app.Run();

record NewTask(string Title);
