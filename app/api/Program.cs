var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
    options.AddPolicy("frontend", policy =>
        policy.WithOrigins("http://localhost:4200")
              .AllowAnyHeader()
              .AllowAnyMethod()));

var app = builder.Build();
app.UseCors("frontend");

var tasks = new List<TaskItem>
{
    new(1, "Set up the repo", true),
    new(2, "Dockerize the API", false)
};

app.MapGet("/health", () => Results.Ok(new { status = "Healthy" }));

app.MapGet("/api/tasks", () => tasks);

app.MapPost("/api/tasks", (NewTask input) =>
{
    var task = new TaskItem(tasks.Count + 1, input.Title, false);
    tasks.Add(task);
    return Results.Created($"/api/tasks/{task.Id}", task);
});

app.Run();

record TaskItem(int Id, string Title, bool Done);
record NewTask(string Title);