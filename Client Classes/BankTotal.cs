using Newtonsoft.Json;

namespace CloudBankTester
{
    class BankTotal
    {

        //Fields
        [JsonProperty("ones")]
        public int ones { get; set; }

        [JsonProperty("fives")]
        public int fives { get; set; }

        [JsonProperty("twentyfives")]
        public int twentyfives { get; set; }

        [JsonProperty("hundreds")]
        public int hundreds { get; set; }

        [JsonProperty("twohundredfifties")]
        public int twohundredfifties { get; set; }

        //Constructors
        public BankTotal()
        {

        }//end of constructor

        public BankTotal(int ones, int fives, int twentyfives, int hundreds, int twohundredfifties)
        {
            this.ones = ones;
            this.fives = fives;
            this.twentyfives = twentyfives;
            this.hundreds = hundreds;
            this.twohundredfifties = twohundredfifties;

        }//end of constructor

    }
}
