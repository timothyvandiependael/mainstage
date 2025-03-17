namespace Mainstage.API.Models
{
    public class ModelBase
    {
        public DateTime CrDate { get; set; }
        public string CrUser { get; set; }
        public DateTime LcDate { get; set; }
        public string LcUser { get; set; }

        public ModelBase()
        {
            CrDate = DateTime.Now;
            LcDate = DateTime.Now;
            CrUser = "sys";
            LcUser = "sys";
        }
    }
}
