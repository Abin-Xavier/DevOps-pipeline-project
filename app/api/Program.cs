using Microsoft.EntityFrameworkCore;
using TaskApi.Data;
using TaskApi.Models;

var builder = WebApplication.CreateBuilder(args);

// With a connection string (local Compose) use SQL Server.
// Without one (the small cloud server) use an in-memory store.
var connectionString = builder.Configuration.GetConnectionString("Default");
var useSqlServer = !string.IsNullOrWhiteSpace(connectionString);

builder.Services.AddDbContext<AppDbContext>(options =>
{
    if (useSqlServer) options.UseSqlServer(connectionString);
    else options.UseInMemoryDatabase("tasks");
});

builder.Services.AddCors(options =>
    options.AddPolicy("frontend", policy =>
        policy.WithOrigins("http://localhost:4200")
              .AllowAnyHeader()
              .AllowAnyMethod()));

var app = builder.Build();
app.UseCors("frontend");

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    if (useSqlServer) db.Database.Migrate();
    else db.Database.EnsureCreated();
}

app.MapGet("/health", () => Results.StatusCode(500)); // BROKEN ON PURPOSE

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

