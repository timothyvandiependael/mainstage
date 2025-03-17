namespace Mainstage.API.Models
{
    public class Tile : ModelBase
    {
        public int Id { get; set; }
        public bool HasCard { get; set; }
        public int ArrowTarget { get; set; }
        public int ArrowSource { get; set; }
        public bool IsStage { get; set; }
        public int Stage { get; set; }
        public int X { get; set; }
        public int Y { get; set; }

    }
}
