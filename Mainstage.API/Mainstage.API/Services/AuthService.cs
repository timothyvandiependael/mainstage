using Mainstage.API.Models;
using Microsoft.AspNetCore.Identity;
using System.Security.Cryptography;
using Microsoft.AspNetCore.WebUtilities;
using System.Text;
using System.Runtime.CompilerServices;
using Mainstage.API.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace Mainstage.API.Services
{
    public class AuthService
    {
        private readonly PasswordHasher<User> _passwordHasher;
        private readonly PasswordHasher<TempUser> _tempUserHasher;
        private readonly AuthContext _authContext;
        private readonly IConfiguration _configuration;
        public AuthService(PasswordHasher<User> passwordHasher, PasswordHasher<TempUser> tempUserHasher, AuthContext authContext, IConfiguration configuration)
        {
            _passwordHasher = passwordHasher;
            _tempUserHasher = tempUserHasher;
            _authContext = authContext;
            _configuration = configuration;
        }

        public bool VerifyPassword(User user, string enteredPassword, string storedHash)
        {
            var result = _passwordHasher.VerifyHashedPassword(user, storedHash, enteredPassword);
            return result == PasswordVerificationResult.Success;
        }

        public string HashPassword(User user, string password)
        {
            return _passwordHasher.HashPassword(user, password);
        }

        public string HashPassword(TempUser user, string password)
        {
            return _tempUserHasher.HashPassword(user, password);
        }

        public string GenerateSecureToken(int size = 32)
        {
            var keyBytes = new byte[size];
            RandomNumberGenerator.Fill(keyBytes);

            return Convert.ToBase64String(keyBytes);
        }

        public string GenerateEmailConfirmationUrl(string baseUrl, string username, string token)
        {
            string encodedToken = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(token));
            var url = $"{baseUrl}?userid={username}&token={encodedToken}";
            return url;
        }

        public string DecodeToken(string encodedToken)
        {
            return System.Text.Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(encodedToken));
        }

        public async Task SaveRefreshToken(string userId, string refreshToken)
        {
            var existingToken = await _authContext.RefreshTokens.FirstOrDefaultAsync(rt => rt.UserId == userId);
            if (existingToken != null)
            {
                existingToken.Token = refreshToken;
                existingToken.Expires = DateTime.Now.AddDays(7);
                _authContext.RefreshTokens.Update(existingToken);
            }
            else
            {
                var newToken = new RefreshToken
                {
                    UserId = userId,
                    Token = refreshToken,
                    Expires = DateTime.Now.AddDays(7)
                };
                _authContext.RefreshTokens.Add(newToken);
            }

            await _authContext.SaveChangesAsync();
        }

        public async Task<RefreshToken> GetRefreshTokenAsync(string refreshToken)
        {
            return await _authContext.RefreshTokens.FirstOrDefaultAsync(r => r.Token == refreshToken && r.Expires > DateTime.Now);
        }

        public string GenerateAccessToken(string userId)
        {
            var claims = new[]
            {
                new Claim(ClaimTypes.Name, userId),
                new Claim(ClaimTypes.Role, "User")
            };

            var secretKey = _configuration["JwtSettings:SecretKey"];
            var key = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(secretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                null,
                null,
                claims,
                expires: DateTime.Now.AddHours(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }


    }
}
