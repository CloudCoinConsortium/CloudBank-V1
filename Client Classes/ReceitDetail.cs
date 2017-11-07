using Newtonsoft.Json;

namespace Founders
{
    public class ReceitDetail
    {
        //Fields
        [JsonProperty("nn")]
        public int nn { get; set; }

        [JsonProperty("sn")]
        public int sn { get; set; }

        [JsonProperty("status")]
        public string status { get; set; }

        [JsonProperty("pown")]
        public string pown { get; set; }

        [JsonProperty("note")]
        public string note { get; set; }


        //Constructors
        public ReceitDetail()
        {

        }//end of constructor

        public ReceitDetail(int nn, int sn, string status, string pown, string note)
        {
            this.nn = nn;
            this.sn = sn;
            this.status = status;
            this.pown = pown;
            this.note = note;

        }//end of constructor

    }//End Class
}//End Namespace
