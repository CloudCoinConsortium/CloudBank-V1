using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;

namespace Billpay
{
    class BillPayRow
    {
        public string Status { get; set; }
        public string PayTo { get; set; }
        public string SendToEmail { get; set; }
        public string Memo { get; set; }
        public int DayOfMonthToPay { get; set; }
        public int Amount { get; set; }
        public string SignedBy { get; set; }
        public string YourEmail { get; set; }
        public string OtherContactInfo { get; set; }
        public int DaysTillExpires { get; set; }
        public string Type { get; set; }



        public BillPayRow(Worksheet ws, int row, string type)
        {

            Status = ws.Cells[row, 1];
            PayTo = ws.Cells[row, 2];
            SendToEmail = ws.Cells[row, 3];
            Memo = ws.Cells[row, 4];
            DayOfMonthToPay = ws.Cells[row, 5];
            Amount = ws.Cells[row, 6];
            SignedBy = ws.Cells[row, 7];
            YourEmail = ws.Cells[row, 8];
            OtherContactInfo = ws.Cells[row, 9];
            DaysTillExpires = ws.Cells[row, 10];

            Type = type;
        }

        public Boolean ActiveAndReady()
        {
            if (Status == "Active" && DayOfMonthToPay == DateTime.Now.Day && DaysTillExpires != 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    
}
