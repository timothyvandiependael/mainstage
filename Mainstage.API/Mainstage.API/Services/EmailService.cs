using Mainstage.API.Models;
using Microsoft.Identity.Client;
using SendGrid;
using SendGrid.Helpers.Mail;
using System.Net;
using System.Net.Mail;

namespace Mainstage.API.Services
{
    public class EmailService
    {
        public EmailService()
        {
           
        }

        public async Task SendEmailAsync(string email, string subject, string message)
        {
            var client = new SmtpClient("smtp.gmail.com")
            {
                Port = 587,
                Credentials = new NetworkCredential("mainstagethegame", "nioy ymej zadw ozqr"),
                EnableSsl = true
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress("mainstagethegame@gmail.com"),
                Subject = subject,
                Body = message,
                IsBodyHtml = true
            };

            mailMessage.To.Add(email);

            await client.SendMailAsync(mailMessage);

        }

        public async Task SendConfirmationEmail(string confirmationUrl, TempUser user)
        {
            var htmlContent = $@"
                <html>
                  <body style='font-family: Arial, sans-serif;'>
                    <h2 style='color: #333;'>Mainstage</h2>
                    <p>Hallo {user.Id},</p>
                    <p>Bedankt voor uw registratie. Klik op de knop hieronder om te bevestigen:</p>
                    <a href='{confirmationUrl}' 
                       style='display: inline-block; padding: 10px 20px; color: #ffffff; background-color: #007BFF; text-decoration: none; border-radius: 5px;'>
                       Bevestig
                    </a>
                    <p>Als u u niet geregistreerd heeft bij Mainstage, negeer dan deze email.</p>
                    <p>Bedankt,<br>Mainstage Team</p>
                  </body>
                </html>
            ";

            await SendEmailAsync(user.Email, "Mainstage Account Confirmation", htmlContent);
        }
    }
}
