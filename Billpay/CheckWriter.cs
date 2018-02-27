using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace Billpay
{
    class CheckWriter
    {
        public string PayTo { get; set; }
        public string SendToEmail { get; set; }
        public string Memo { get; set; }
        public int Amount { get; set; }
        public string SignedBy { get; set; }
        public string FromEmail { get; set; }

        
        public CheckWriter(BillPayRow bpr)
        {
            PayTo = bpr.PayTo;
            SendToEmail = bpr.SendToEmail;
            Memo = bpr.Memo;
            Amount = bpr.Amount;
            SignedBy = bpr.SignedBy;
            FromEmail = bpr.YourEmail;
        }

        public async void SendCheck()
        {
            //HttpClient cli = new HttpClient();
            //var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("pk", ConfigurationManager.AppSettings["root"]) });
            //var result = await cli.PostAsync("https://" + ConfigurationManager.AppSettings["BankServerPath"] + "write_check.aspx?action=email&amount=" + Amount + "&emailto=" + SendToEmail + "&payto=" + PayTo + "&from=" + FromEmail + "&signby=" + SignedBy, formContent);
            //string response = await result.Content.ReadAsStringAsync();
            //Console.Out.WriteLine(response);
            //Console.ReadLine();

            var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("pk", "0DECE3AF-43EC-435B-8C39-E2A5D0EA8676") });


            HttpClient cli = new HttpClient();
            try
            {
                var result_stack = await cli.PostAsync("https://" + ConfigurationManager.AppSettings["BankServerPath"] + "write_check.aspx?action=email&amount=" + Amount + "&emailto=" + SendToEmail + "&payto=" + PayTo + "&from=" + FromEmail + "&signby=" + SignedBy, formContent);
                var response = await result_stack.Content.ReadAsStringAsync();
            }
            catch (Exception ex)
            {
                Console.Out.WriteLine(ex.Message);
            }

        }

    }
}
