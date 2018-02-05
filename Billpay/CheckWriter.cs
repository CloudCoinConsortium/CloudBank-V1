using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public void SendCheck()
        {

        }

    }
}
