using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Founders;

namespace CloudCoinSender
{
    public class CloudCoinSender
    {
        

        // Fields /
        string cloudBankURL;
        string rawStack;
        string rawReceipt;
        object purchaseOrder;
        HttpClient cli = new HttpClient();

        // Constructors /
        public CloudCoinSender( string cloudBankURL)
        {
        rawStack = "";
        rawReceipt = "";
        this.cloudBankURL = cloudBankURL;
        }//end constructor

        // METHODS /
        public void loadStackFromFile(string filename)
        {
            //rawStack = ReadFile( filename);
            rawStack = File.ReadAllText(filename);
        }

        public async void sendStackToCloudBank( )
        {
          string CloudBankFeedback = "";
            var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("stack", rawStack) });
            var result_stack = await cli.PostAsync(cloudBankURL+"/deposite_one_stack.aspx", formContent);
             CloudBankFeedback = await result_stack.Content.ReadAsStringAsync();
            var cbf = JsonConvert.DeserializeObject<Dictionary<string, string>>(CloudBankFeedback);
            if (cbf["status"] == "importing")
            {
                var result_receipt = await cli.GetAsync(cloudBankURL+"/get_receipt.aspx?rn=" + cbf["receipt"]);
                rawReceipt = await result_receipt.Content.ReadAsStringAsync();
            }
          //rawReceipt = POST(cloudBankURL, rawStack);
        }

        public string interpretReceipt(){
            string interpretation = "";
            if (rawReceipt.Contains("Error"))
            {
                //parse out message
                interpretation = rawReceipt;
            }else{
                //tell the client how many coins were uploaded how many counterfeit, etc.
                var deserialReceipt = JsonConvert.DeserializeObject<Receipt>(rawReceipt);
                interpretation = "total authentic: " + deserialReceipt.total_authentic + ", total fracked: " + deserialReceipt.total_fracked + " total counterfeit: " + deserialReceipt.total_counterfeit;


         }//end if error
            return interpretation;
        }

        }//end Class CloudCoinSender
        

    
}
