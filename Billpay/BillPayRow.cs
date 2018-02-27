using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;

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
        public DateTime DateExpires { get; set; }
        public string Type { get; set; }



        public BillPayRow(WorkbookPart wbp, int row, string type)
        {
            int worksheetcount = wbp.Workbook.Sheets.Count();
            Sheet mysheet;

            if (type == "Payonce")
            {
                mysheet = (Sheet)wbp.Workbook.Sheets.ChildElements.GetItem(1);
            }
            else
            {
                mysheet = (Sheet)wbp.Workbook.Sheets.ChildElements.GetItem(0);
            }
            WorksheetPart WorkSheetP = (WorksheetPart)wbp.GetPartById(mysheet.Id);
            DocumentFormat.OpenXml.Spreadsheet.Worksheet Worksheet = WorkSheetP.Worksheet;

            int wkschildno = 4;
            SheetData Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);

            Row currentrow = (Row)Rows.ChildElements.GetItem(row - 1);

            Cell currentcell1 = (Cell)currentrow.ChildElements.GetItem(0);
            Status = getString(wbp, currentcell1);
            Cell currentcell2 = (Cell)currentrow.ChildElements.GetItem(1);
            PayTo = getString(wbp, currentcell2);
            Cell currentcell3 = (Cell)currentrow.ChildElements.GetItem(2);
            SendToEmail = getString(wbp, currentcell3);
            Cell currentcell4 = (Cell)currentrow.ChildElements.GetItem(3);
            Memo = getString(wbp, currentcell4);
            Cell currentcell5 = (Cell)currentrow.ChildElements.GetItem(4);
            DayOfMonthToPay = int.Parse(currentcell5.CellValue.InnerText);
            Cell currentcell6 = (Cell)currentrow.ChildElements.GetItem(5);
            Amount = int.Parse(currentcell6.CellValue.InnerText);
            Cell currentcell7 = (Cell)currentrow.ChildElements.GetItem(6);
            SignedBy = getString(wbp, currentcell7);
            Cell currentcell8 = (Cell)currentrow.ChildElements.GetItem(7);
            string YourEmail = getString(wbp, currentcell8);
            Cell currentcell9 = (Cell)currentrow.ChildElements.GetItem(8);
            OtherContactInfo = getString(wbp, currentcell9);
            Cell currentcell10 = (Cell)currentrow.ChildElements.GetItem(9);
            string Date = currentcell10.CellValue.InnerText;
            double d = double.Parse(Date);
            DateExpires = DateTime.FromOADate(d);

            Type = type;
        }

        public Boolean ActiveAndReady()
        {
            if (Status == "Active" && DayOfMonthToPay == DateTime.Now.Day && DateTime.Now < DateExpires)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static string getString(WorkbookPart wbp, Cell c)
        {
            string currentcellvalue = "";

            if (c.DataType != null)
            {
                if (c.DataType == CellValues.SharedString)
                {
                    int id = -1;



                    if (Int32.TryParse(c.InnerText, out id))
                    {
                        SharedStringItem item = wbp.SharedStringTablePart.SharedStringTable.Elements<SharedStringItem>().ElementAt(id);

                        if (item.Text != null)
                        {
                            //code to take the string value  
                            currentcellvalue = item.Text.Text;
                        }
                        else if (item.InnerText != null)
                        {
                            currentcellvalue = item.InnerText;
                        }
                        else if (item.InnerXml != null)
                        {
                            currentcellvalue = item.InnerXml;
                        }
                    }
                }
            }
            return currentcellvalue;
        }
    }

    
}
