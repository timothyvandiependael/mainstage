using Microsoft.EntityFrameworkCore;
using Mainstage.API.Data;
using Mainstage.API.Models;


var optionsBuilder = new DbContextOptionsBuilder<MainstageContext>();
optionsBuilder.UseSqlServer(@"Server=MSI;Database=Mainstage;User Id=mainstage;Password=Tlb192H4c3HL5FgtNkQJ;TrustServerCertificate=True;");

using (var context = new MainstageContext(optionsBuilder.Options))
{
    try
    {
        var card = context.Cards.FirstOrDefault();

        if (card != null)
        {
            Console.WriteLine("card: {card.Id}");
        }
        else
        {
            Console.WriteLine("Card is null");
        }
    }
    catch (Exception ex) 
    {
        Console.WriteLine(ex.Message);
        if (ex.InnerException != null)
        {
            Console.WriteLine("Inner ex: " + ex.InnerException.Message);
        }
    }
}

Console.ReadLine();

