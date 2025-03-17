using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Mainstage.API.Models;
using Mainstage.API.Data;
using Mainstage.API.Services;
using Microsoft.AspNetCore.Http;
using Azure.Core;
using Microsoft.AspNetCore.Identity;
using Mainstage.API.Managers;

namespace Mainstage.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AccountController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly AuthService _authService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly EmailService _emailService;
        private readonly TempUserManager _tempUserManager;
        private readonly UserManager _userManager;
        private readonly PlayerManager _playerManager;

        public AccountController(IConfiguration configuration, AuthService authService, UserManager userManager,
            IHttpContextAccessor httpContextAccessor, EmailService emailService, TempUserManager tempUserManager,
            PlayerManager playerManager)
        {
            _configuration = configuration;
            _authService = authService;
            _userManager = userManager;
            _httpContextAccessor = httpContextAccessor;
            _emailService = emailService;
            _tempUserManager = tempUserManager;
            _playerManager = playerManager;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterModel model)
        {
            await _tempUserManager.DeleteOldEntries();

            if (model == null || string.IsNullOrEmpty(model.Username) || string.IsNullOrEmpty(model.Password))
            {
                return BadRequest("Voer een gebruikersnaam, wachtwoord en e-mailadres in.");
            }
            else
            {
                var existingUser = await _userManager.GetByIdAsync(model.Username);
                
                if (existingUser != null)
                {
                    return BadRequest("Gebruikersnaam bestaat al.");
                }

                var existingTempUser = await _tempUserManager.GetByIdAsync(model.Username);
                if (existingTempUser != null)
                {
                    return BadRequest("Er loopt al een registratieprocedure voor deze gebruikersnaam. Check uw e-mail.");
                }

                var token = _authService.GenerateSecureToken();

                var user = new Models.TempUser()
                {
                    Id = model.Username,
                    Password = model.Password,
                    Email = model.Email,
                    Token = token,
                    TokenExpirationDate = DateTime.Now.AddHours(1),
                    CrDate = DateTime.Now,
                    CrUser = model.Username,
                    LcDate = DateTime.Now,
                    LcUser = model.Username
                };

                user.Password = _authService.HashPassword(user, model.Password);

                await _tempUserManager.AddAsync(user);

                var confirmationUrl = @"http://localhost:4200/confirm-email";

                var confirmationLink = _authService.GenerateEmailConfirmationUrl(confirmationUrl, user.Id, user.Token);

                await _emailService.SendConfirmationEmail(confirmationLink, user);

                return Ok(new { message = "Registratie gelukt. Check uw e-mail om registratie te bevestigen." });
            }

            return BadRequest("Er is een fout opgetreden.");
        }

        [HttpGet("confirmemail")]
        public async Task<IActionResult> ConfirmEmail(string userid, string token)
        {
            var tempUser = await _tempUserManager.GetByIdAsync(userid);

            if (tempUser == null)
            {
                return BadRequest("Ongeldige gebruiker.");
            }
            else
            {
                if (tempUser.Token != _authService.DecodeToken(token))
                {
                    return BadRequest("Ongeldige link.");
                }

                var user = new User
                {
                    Id = tempUser.Id,
                    Password = tempUser.Password,
                    Email = tempUser.Email,
                    CrDate = DateTime.Now,
                    CrUser = tempUser.Id,
                    LcDate = DateTime.Now,
                    LcUser = tempUser.Id
                };

                await _userManager.AddAsync(user);
                await _tempUserManager.DeleteAsync(user.Id);

                var player = new Player
                {
                    Id = user.Id,
                    CrDate = DateTime.Now,
                    CrUser = tempUser.Id,
                    LcDate = DateTime.Now,
                    LcUser = tempUser.Id
                };

                await _playerManager.AddAsync(player);

                return Ok(new { message = "Account succesvol bevestigd!" });
            }
        }

        [HttpPost("createuser")]
        public async Task<IActionResult> CreateUser([FromBody] LoginModel model)
        {
            var user = new Models.User()
            {
                Id = model.Username,
                Password = model.Password,
                CrDate = DateTime.Now,
                CrUser = model.Username,
                LcDate = DateTime.Now,
                LcUser = model.Username
            };

            user.Password = _authService.HashPassword(user, model.Password);

            await _userManager.AddAsync(user);

            return Ok(new { message = "alles ok" });
        }

        [HttpPost("refresh")]
        public async Task<IActionResult> Refresh([FromBody] string refreshToken)
        {
            var storedRefreshToken = await _authService.GetRefreshTokenAsync(refreshToken);
            if (storedRefreshToken == null || storedRefreshToken.Expires < DateTime.Now)
            {
                return Unauthorized("Refresh token ongeldig of verlopen.");
            }

            var dbUser = await _userManager.GetByIdAsync(storedRefreshToken.UserId);
            if (dbUser == null)
            {
                return Unauthorized("Gebruiker niet gevonden.");
            }

            var newAccessToken = _authService.GenerateAccessToken(dbUser.Id);
            var newRefreshToken = _authService.GenerateSecureToken();
            await _authService.SaveRefreshToken(dbUser.Id, newRefreshToken);

            return Ok(new { Token = newAccessToken, RefreshToken = newRefreshToken });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {
            if (model == null || string.IsNullOrEmpty(model.Username) || string.IsNullOrEmpty(model.Password))
            {
                return BadRequest("Voer een gebruikersnaam en wachtwoord in.");
            }
            else
            {
                var dbUser = await _userManager.GetByIdAsync(model.Username);
                if (dbUser == null)
                {
                    return Unauthorized("Gebruiker niet gevonden.");
                }

                var correctPassword = _authService.VerifyPassword(dbUser, model.Password, dbUser.Password);
                if (!correctPassword)
                {
                    return Unauthorized("Ongeldig wachtwoord.");
                }

                var tokenString = _authService.GenerateAccessToken(dbUser.Id);

                var refreshToken = _authService.GenerateSecureToken();
                await _authService.SaveRefreshToken(dbUser.Id, refreshToken);

                Response.Cookies.Append("tokenKey", tokenString, new CookieOptions
                {
                    HttpOnly = true,
                    Secure = true,
                    Expires = DateTime.Now.AddHours(1)
                });

                return Ok(new { Token = tokenString, RefreshToken = refreshToken });
            }
        }
        
    }
}
