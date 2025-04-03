using Mainstage.API.Data;
using Mainstage.API.Services;
using Microsoft.EntityFrameworkCore;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Mainstage.API.Models;
using Microsoft.AspNetCore.Identity;
using Mainstage.API.Managers;
using Mainstage.API.SignalR;

var builder = WebApplication.CreateBuilder(args);

var secretKey = builder.Configuration["JwtSettings:SecretKey"];
var key = Encoding.ASCII.GetBytes(secretKey);
var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";

builder.Services.AddCors(options =>
{
    options.AddPolicy(name: MyAllowSpecificOrigins,
        policy =>
        {
            policy.WithOrigins("http://localhost:4200")
               .AllowAnyHeader()
               .AllowAnyMethod()
               .AllowCredentials();
        });
});

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = true,
            IssuerSigningKey = new SymmetricSecurityKey(key)
        };

        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                var accessToken = context.Request.Query["access_token"];

                var path = context.HttpContext.Request.Path;
                if (!string.IsNullOrEmpty(accessToken))
                {
                    if (path.StartsWithSegments("/lobbyhub") || path.StartsWithSegments("/gamehub"))
                    {
                        context.Token = accessToken;
                    }
                }

                return Task.CompletedTask;
            }
        };
    });

builder.Services.AddSignalR(options =>
{
    options.ClientTimeoutInterval = TimeSpan.FromMinutes(10);
    options.KeepAliveInterval = TimeSpan.FromMinutes(2);
    options.EnableDetailedErrors = true;
    options.MaximumReceiveMessageSize = 1024 * 1024 * 10;
});

// Register the database context
builder.Services.AddDbContext<MainstageContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("MainstageConnection")));
builder.Services.AddDbContext<AuthContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("AuthConnection")));

// Add services to the container.
builder.Services.AddHttpContextAccessor();

builder.Services.AddScoped<PasswordHasher<User>>();
builder.Services.AddScoped<PasswordHasher<TempUser>>();

builder.Services.AddScoped<CardManager>();
builder.Services.AddScoped<GameActionManager>();
builder.Services.AddScoped<GameCardManager>();
builder.Services.AddScoped<GameManager>();
builder.Services.AddScoped<GamePlayerCardManager>();
builder.Services.AddScoped<GamePlayerManager>();
builder.Services.AddScoped<PlayerManager>();
builder.Services.AddScoped<TempUserManager>();
builder.Services.AddScoped<TileManager>();
builder.Services.AddScoped<UserManager>();
builder.Services.AddScoped<ChatMessageManager>();
builder.Services.AddScoped<GameOptionsManager>();

builder.Services.AddScoped<GameActionService>();
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<CardService>();
builder.Services.AddScoped<GameLogicService>();
builder.Services.AddScoped<EmailService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.MapHub<LobbyHub>("/lobbyhub");
app.MapHub<GameHub>("/gamehub");

app.UseCors(MyAllowSpecificOrigins);

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
