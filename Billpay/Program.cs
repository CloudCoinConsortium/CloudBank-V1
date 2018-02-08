using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;

namespace Billpay
{
    class Program
    {
        private static Workbook MyBook = null;
        private static Application MyApp = null;
        private static Worksheet MySheet = null;


        static void Main(string[] args)
        {

            MyApp = new Application
            {
                Visible = false
            };

            MyBook = MyApp.Workbooks.Open(AppDomain.CurrentDomain.BaseDirectory + @"\billpay.xlsx");
            MySheet = (Worksheet)MyBook.Sheets[1];

            Range last = MySheet.Cells.SpecialCells(XlCellType.xlCellTypeLastCell, Type.Missing);
            int lastRow = last.Row + 1;

            for (int i = 2;i < lastRow;i++)
            {
                BillPayRow bpr = new BillPayRow(MySheet, i, "Reoccurring");
                if (bpr.ActiveAndReady())
                {
                    CheckWriter cw = new CheckWriter(bpr);
                    cw.SendCheck();
                }
            }

            MySheet = (Worksheet)MyBook.Sheets[2];

            Range last2 = MySheet.Cells.SpecialCells(XlCellType.xlCellTypeLastCell, Type.Missing);
            int lastRow2 = last2.Row + 1;

            for (int i = 2; i < lastRow2; i++)
            {
                BillPayRow bpr = new BillPayRow(MySheet, i, "Payonce");
                if (bpr.ActiveAndReady())
                {
                    CheckWriter cw = new CheckWriter(bpr);
                    cw.SendCheck();
                }
            }

        }
    }
}
