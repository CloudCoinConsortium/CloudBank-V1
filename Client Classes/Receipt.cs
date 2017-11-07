using Newtonsoft.Json;
namespace Founders
{
    public class Receipt
    {
        [JsonProperty("receipt_id")]
        public string receipt_id { get; set; }

        [JsonProperty("time")]
        public string time { get; set; }

        [JsonProperty("timezone")]
        public string timezone { get; set; }

        [JsonProperty("bank_server")]
        public string bank_server { get; set; }

        [JsonProperty("total_authentic")]
        public int total_authentic { get; set; }

        [JsonProperty("total_fracked")]
        public int total_fracked { get; set; }

        [JsonProperty("total_counterfeit")]
        public int total_counterfeit { get; set; }

        [JsonProperty("total_lost")]
        public int total_lost { get; set; }

        [JsonProperty("receipt")]
        public ReceitDetail[] rd { get; set; }

    }
}
