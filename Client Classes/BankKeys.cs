using Newtonsoft.Json;

namespace CloudBankTester
{
    /*
     example json file: 
   
        {
           "publickey":"preston.CloudCoin.Global",
           "privatekey":"6e2b96d6204a4212ae57ab84260e747f",
           "email":""
         }
         */

    public class BankKeys
    {
        //Fields
        [JsonProperty("publickey")]
        public string publickey { get; set; }

        [JsonProperty("privatekey")]
        public string privatekey { get; set; }

        [JsonProperty("email")]
        public string email { get; set; }


        //Constructors
        public BankKeys()
        {

        }//end of constructor

        public BankKeys(string publickey, string privatekey, string email)
        {
            this.publickey = publickey;
            this.privatekey = privatekey;
            this.email = email;
        }//end of constructor


    }
}
