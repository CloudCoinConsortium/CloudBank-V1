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
            HttpClient cli = new HttpClient();
            var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("pk", ConfigurationSettings.AppSettings["root"]) });
            var result = await cli.PostAsync("https://" + ConfigurationSettings.AppSettings["thisServerPath"] + "/write_check.aspx?action=email&amount=" + Amount + "&emailto=" + SendToEmail + "&payto=" + PayTo + "&from=" + FromEmail + "&signby=" + SignedBy, formContent);
            string response = await result.Content.ReadAsStringAsync();
        }

    }
}
