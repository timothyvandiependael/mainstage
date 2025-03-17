using System.ComponentModel.DataAnnotations;

namespace Mainstage.API.Models
{
    public class Card : ModelBase
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool IsKeeper { get; set; }
        public string CardType { get; set; }
        public string Parameter1Name { get; set; }
        public string Parameter1 { get; set; }
        public string Parameter2Name { get; set; }
        public string Parameter2 { get; set; }
        public string Parameter3Name { get; set; }
        public string Parameter3 { get; set; }
        public string Parameter4Name { get; set; }
        public string Parameter4 { get; set; }

    }
}
