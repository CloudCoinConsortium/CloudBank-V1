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

        public async Task sendStackToCloudBank( )
        {
          string CloudBankFeedback = "";
            var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("stack", rawStack) });
            var result_stack = await cli.PostAsync(cloudBankURL+"/deposit_one_stack.aspx", formContent);
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
                int totalNotes = deserialReceipt.total_authentic + deserialReceipt.total_fracked;
                int totalCoins = 0;
                for (int i = 0; i < deserialReceipt.rd.Length; i++)
                    if (deserialReceipt.rd[i].status == "authentic")
                        totalCoins += getDenomination(deserialReceipt.rd[i].sn);
                interpretation ="receipt number: " + deserialReceipt.receipt_id + " total authentic notes: " + totalNotes + " total authentic coins: " + totalCoins;


         }//end if error
            return interpretation;
        }

        private int getDenomination(int sn)
        {
            int nom = 0;
            if ((sn < 1))
            {
                nom = 0;
            }
            else if ((sn < 2097153))
            {
                nom = 1;
            }
            else if ((sn < 4194305))
            {
                nom = 5;
            }
            else if ((sn < 6291457))
            {
                nom = 25;
            }
            else if ((sn < 14680065))
            {
                nom = 100;
            }
            else if ((sn < 16777217))
            {
                nom = 250;
            }
            else
            {
                nom = '0';
            }

            return nom;
        }//end get denomination

    }//end Class CloudCoinSender
        

    
}
