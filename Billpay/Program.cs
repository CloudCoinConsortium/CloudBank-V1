using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;
using DocumentFormat.OpenXml.Packaging;
using System.Web.Configuration;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Configuration;

namespace Billpay
{
    class Program
    {
        
        static void Main(string[] args)
        {

            //string filepath = AppDomain.CurrentDomain.BaseDirectory + @"\" + WebConfigurationManager.AppSettings["root"] + @"\billpay.xlsx";
            string filepath = AppDomain.CurrentDomain.BaseDirectory + ConfigurationManager.AppSettings["root"] + @"\billpay.xlsx";

            //open the excel using openxml sdk  
            using (SpreadsheetDocument doc = SpreadsheetDocument.Open(filepath, true))
            {
                WorkbookPart wbPart = doc.WorkbookPart;
                int worksheetcount = doc.WorkbookPart.Workbook.Sheets.Count();
                Sheet MySheet = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(0);
                WorksheetPart WorkSheetP = (WorksheetPart)wbPart.GetPartById(MySheet.Id);
                DocumentFormat.OpenXml.Spreadsheet.Worksheet Worksheet = WorkSheetP.Worksheet;

                int wkschildno = 4;
                SheetData Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);

                Row lastRow = Rows.Elements<Row>().LastOrDefault();

                for (int i = 2;i <= Rows.Count();i++)
                {
                    BillPayRow bpr = new BillPayRow(wbPart, i, "Reoccurring");
                    if (bpr.ActiveAndReady())
                    {
                        CheckWriter cw = new CheckWriter(bpr);
                        cw.SendCheck();
                    }
                }

                Sheet MySheet2 = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(1);
                WorksheetPart WorkSheetP2 = (WorksheetPart)wbPart.GetPartById(MySheet2.Id);
                DocumentFormat.OpenXml.Spreadsheet.Worksheet Worksheet2 = WorkSheetP2.Worksheet;

                SheetData Rows2 = (SheetData)Worksheet2.ChildElements.GetItem(wkschildno);

                Row lastRow2 = Rows2.Elements<Row>().LastOrDefault();

                
                for (int i = 2; i <= Rows2.Count(); i++)
                {
                    BillPayRow bpr = new BillPayRow(wbPart, i, "Payonce");
                    if (bpr.ActiveAndReady())
                    {
                        CheckWriter cw = new CheckWriter(bpr);
                        cw.SendCheck();
                    }
                }
            }

            System.Threading.Thread.Sleep(15000);

        }
    }
}
