using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using Founders;
using System.IO;
using System.Threading.Tasks;

namespace CloudCoinSender
{
    public class CloudCoinReceiver
    {
            // Fields /
        string cloudBankURL;
        public string rawStack;
        string receiptNumber;
        int totalCoins;
        HttpClient cli = new HttpClient();


        // Constructors /
        public CloudCoinReceiver(string cloudBankURL, string receiptNumber)
        {
             rawStack = "";
             this.cloudBankURL = cloudBankURL;
             this.receiptNumber = receiptNumber;
             this.totalCoins = 0;
        }//end constructor

    // METHODS /
        public async Task getStackFromCloudBank()
        {
            var result_receipt = await cli.GetAsync(cloudBankURL + "/get_receipt.aspx?rn=" + receiptNumber);
            string rawReceipt = await result_receipt.Content.ReadAsStringAsync();
            if (rawReceipt.Contains("Error"))
            {
                Console.WriteLine(rawReceipt);
            }
            else
            {
                var deserialReceipt = JsonConvert.DeserializeObject<Receipt>(rawReceipt);
                for (int i = 0; i < deserialReceipt.rd.Length; i++)
                    if(deserialReceipt.rd[i].status == "authentic")
                    totalCoins += getDenomination(deserialReceipt.rd[i].sn);
                var result_stack = await cli.GetAsync(cloudBankURL + "/withdraw_one_stack.aspx?amount=" + totalCoins);
                rawStack = await result_stack.Content.ReadAsStringAsync();
                //rawStack = GET(cloudBankURL, receiptNumber);
            }
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

        public void saveStackToFile(string path)
        {
            File.WriteAllText(path+ getStackName(), rawStack);
            //WriteFile(path + stackName, rawStack);
        }

        public string getStackName()
        {
            return totalCoins + ".cloudcoin." + receiptNumber + ".stack";
        }

    }
}
