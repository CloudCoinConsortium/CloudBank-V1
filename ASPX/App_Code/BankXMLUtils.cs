using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Web.Configuration;

/// <summary>
/// Summary description for BankXMLUtils
/// </summary>
public class BankXMLUtils
{
    public BankXMLUtils()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void AddToPendingChecks(Guid guidout, string payto, string emailto, string memo, double amount, string signedby, string youremail, string othercontactinfo)
    {
        string filepath = AppDomain.CurrentDomain.BaseDirectory + @"\" + WebConfigurationManager.AppSettings["root"] + @"\billpay.xlsx";

        //open the excel using openxml sdk  
        using (SpreadsheetDocument doc = SpreadsheetDocument.Open(filepath, true))
        {
            WorkbookPart wbPart = doc.WorkbookPart;
            int worksheetcount = doc.WorkbookPart.Workbook.Sheets.Count();
            Sheet mysheet = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(2);
            WorksheetPart WorkSheetP = (WorksheetPart)wbPart.GetPartById(mysheet.Id);
            Worksheet Worksheet = WorkSheetP.Worksheet;

            int NewRow = InsertRow(WorkSheetP);

            SharedStringTablePart shareStringPart;
            if (doc.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
            {
                shareStringPart = doc.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
            }
            else
            {
                shareStringPart = doc.WorkbookPart.AddNewPart<SharedStringTablePart>();
            }

            int wkschildno = 4;
            SheetData Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);
            Row currentrow = (Row)Rows.ChildElements.GetItem(NewRow);

            Cell newCell0 = new Cell();
            currentrow.InsertAt(newCell0, 0);
            int index0 = InsertSharedStringItem("Pending", shareStringPart);
            newCell0.CellValue = new CellValue(index0.ToString());
            newCell0.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell1 = new Cell();
            currentrow.InsertAt(newCell1, 1);
            int index1 = InsertSharedStringItem(guidout.ToString(), shareStringPart);
            newCell1.CellValue = new CellValue(index1.ToString());
            newCell1.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell2 = new Cell();
            currentrow.InsertAt(newCell2, 2);
            int index2 = InsertSharedStringItem(payto, shareStringPart);
            newCell2.CellValue = new CellValue(index2.ToString());
            newCell2.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell3 = new Cell();
            currentrow.InsertAt(newCell3, 3);
            int index3 = InsertSharedStringItem(emailto, shareStringPart);
            newCell3.CellValue = new CellValue(index3.ToString());
            newCell3.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell4 = new Cell();
            currentrow.InsertAt(newCell4, 4);
            int index4 = InsertSharedStringItem(memo, shareStringPart);
            newCell4.CellValue = new CellValue(index4.ToString());
            newCell4.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell5 = new Cell();
            currentrow.InsertAt(newCell5, 5);
            int index5 = InsertSharedStringItem(DateTime.Now.ToString(), shareStringPart);
            newCell5.CellValue = new CellValue(index5.ToString());
            newCell5.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell6 = new Cell();
            currentrow.InsertAt(newCell6, 6);
            newCell6.CellValue = new CellValue(amount.ToString());
            newCell6.DataType = new EnumValue<CellValues>(CellValues.Number);

            Cell newCell7 = new Cell();
            currentrow.InsertAt(newCell7, 7);
            int index7 = InsertSharedStringItem(signedby, shareStringPart);
            newCell7.CellValue = new CellValue(index7.ToString());
            newCell7.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell8 = new Cell();
            currentrow.InsertAt(newCell8, 8);
            int index8 = InsertSharedStringItem(youremail, shareStringPart);
            newCell8.CellValue = new CellValue(index8.ToString());
            newCell8.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell9 = new Cell();
            currentrow.InsertAt(newCell9, 9);
            int index9 = InsertSharedStringItem(othercontactinfo, shareStringPart);
            newCell9.CellValue = new CellValue(index9.ToString());
            newCell9.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            WorkSheetP.Worksheet.Save();
        }

        
    }

    public int FindCheckRow(string guid)
    {
        string filepath = AppDomain.CurrentDomain.BaseDirectory + @"\" + WebConfigurationManager.AppSettings["root"] + @"\billpay.xlsx";

        //open the excel using openxml sdk  
        using (SpreadsheetDocument doc = SpreadsheetDocument.Open(filepath, true))
        {
            WorkbookPart wbPart = doc.WorkbookPart;
            int worksheetcount = doc.WorkbookPart.Workbook.Sheets.Count();
            Sheet mysheet = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(2);
            WorksheetPart WorkSheetP = (WorksheetPart)wbPart.GetPartById(mysheet.Id);
            Worksheet Worksheet = WorkSheetP.Worksheet;

            int wkschildno = 4;
            SheetData Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);

            for (int index = 0;index < Rows.Count();index++)
            {
                Row currentrow = (Row)Rows.ChildElements.GetItem(index);

                Cell currentcell = (Cell)currentrow.ChildElements.GetItem(1);

                string currentcellvalue = string.Empty;


                if (currentcell.DataType != null)
                {
                    if (currentcell.DataType == CellValues.SharedString)
                    {
                        currentcellvalue = getString(wbPart, currentcell);
                    }
                }

                if (currentcellvalue == guid)
                {
                    return index + 1;
                }
            }

            return -1;
        }
    }

    public void MarkCheckPaid(int checkRow)
    {
        int checkIndex = checkRow - 1;

        string filepath = AppDomain.CurrentDomain.BaseDirectory + @"\" + WebConfigurationManager.AppSettings["root"] + @"\billpay.xlsx";

        //open the excel using openxml sdk  
        using (SpreadsheetDocument doc = SpreadsheetDocument.Open(filepath, true))
        {
            WorkbookPart wbPart = doc.WorkbookPart;
            int worksheetcount = doc.WorkbookPart.Workbook.Sheets.Count();
            Sheet mysheet = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(2);
            WorksheetPart WorkSheetP = (WorksheetPart)wbPart.GetPartById(mysheet.Id);
            Worksheet Worksheet = WorkSheetP.Worksheet;

            int wkschildno = 4;
            SheetData Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);

            Row currentrow = (Row)Rows.ChildElements.GetItem(checkIndex);

            Cell currentcell1 = (Cell)currentrow.ChildElements.GetItem(1);
            string guid = getString(wbPart, currentcell1);
            Cell currentcell2 = (Cell)currentrow.ChildElements.GetItem(2);
            string payto = getString(wbPart, currentcell2);
            Cell currentcell3 = (Cell)currentrow.ChildElements.GetItem(3);
            string emailto = getString(wbPart, currentcell3);
            Cell currentcell4 = (Cell)currentrow.ChildElements.GetItem(4);
            string memo = getString(wbPart, currentcell4);
            Cell currentcell6 = (Cell)currentrow.ChildElements.GetItem(6);
            double amount = double.Parse(currentcell6.CellValue.InnerText);
            Cell currentcell7 = (Cell)currentrow.ChildElements.GetItem(7);
            string signedby = getString(wbPart, currentcell7);
            Cell currentcell8 = (Cell)currentrow.ChildElements.GetItem(8);
            string youremail = getString(wbPart, currentcell8);
            Cell currentcell9 = (Cell)currentrow.ChildElements.GetItem(9);
            string othercontactinfo = getString(wbPart, currentcell9);

            mysheet = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(3);
            WorkSheetP = (WorksheetPart)wbPart.GetPartById(mysheet.Id);
            Worksheet = WorkSheetP.Worksheet;

            Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);

            int NewRow = InsertRow(WorkSheetP);

            currentrow = (Row)Rows.ChildElements.GetItem(NewRow);

            SharedStringTablePart shareStringPart;
            if (doc.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
            {
                shareStringPart = doc.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
            }
            else
            {
                shareStringPart = doc.WorkbookPart.AddNewPart<SharedStringTablePart>();
            }


            Cell newCell0 = new Cell();
            currentrow.InsertAt(newCell0, 0);
            int index0 = InsertSharedStringItem("Paid", shareStringPart);
            newCell0.CellValue = new CellValue(index0.ToString());
            newCell0.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell1 = new Cell();
            currentrow.InsertAt(newCell1, 1);
            int index1 = InsertSharedStringItem(guid.ToString(), shareStringPart);
            newCell1.CellValue = new CellValue(index1.ToString());
            newCell1.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell2 = new Cell();
            currentrow.InsertAt(newCell2, 2);
            int index2 = InsertSharedStringItem(payto, shareStringPart);
            newCell2.CellValue = new CellValue(index2.ToString());
            newCell2.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell3 = new Cell();
            currentrow.InsertAt(newCell3, 3);
            int index3 = InsertSharedStringItem(emailto, shareStringPart);
            newCell3.CellValue = new CellValue(index3.ToString());
            newCell3.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell4 = new Cell();
            currentrow.InsertAt(newCell4, 4);
            int index4 = InsertSharedStringItem(memo, shareStringPart);
            newCell4.CellValue = new CellValue(index4.ToString());
            newCell4.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell5 = new Cell();
            currentrow.InsertAt(newCell5, 5);
            newCell5.CellValue = new CellValue(amount.ToString());
            newCell5.DataType = new EnumValue<CellValues>(CellValues.Number);

            Cell newCell6 = new Cell();
            currentrow.InsertAt(newCell6, 6);
            int index6 = InsertSharedStringItem(signedby, shareStringPart);
            newCell6.CellValue = new CellValue(index6.ToString());
            newCell6.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell7 = new Cell();
            currentrow.InsertAt(newCell7, 7);
            int index7 = InsertSharedStringItem(youremail, shareStringPart);
            newCell7.CellValue = new CellValue(index7.ToString());
            newCell7.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell8 = new Cell();
            currentrow.InsertAt(newCell8, 8);
            int index8 = InsertSharedStringItem(othercontactinfo, shareStringPart);
            newCell8.CellValue = new CellValue(index8.ToString());
            newCell8.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            Cell newCell9 = new Cell();
            currentrow.InsertAt(newCell9, 9);
            int index9 = InsertSharedStringItem(DateTime.Now.ToString(), shareStringPart);
            newCell9.CellValue = new CellValue(index9.ToString());
            newCell9.DataType = new EnumValue<CellValues>(CellValues.SharedString);

            WorkSheetP.Worksheet.Save();
        }
    }

    public void DeleteFromPending(int checkRow)
    {
        string filepath = AppDomain.CurrentDomain.BaseDirectory + @"\" + WebConfigurationManager.AppSettings["root"] + @"\billpay.xlsx";

        //open the excel using openxml sdk  
        using (SpreadsheetDocument doc = SpreadsheetDocument.Open(filepath, true))
        {
            WorkbookPart wbPart = doc.WorkbookPart;
            int worksheetcount = doc.WorkbookPart.Workbook.Sheets.Count();
            Sheet mysheet = (Sheet)doc.WorkbookPart.Workbook.Sheets.ChildElements.GetItem(2);
            WorksheetPart WorkSheetP = (WorksheetPart)wbPart.GetPartById(mysheet.Id);
            Worksheet Worksheet = WorkSheetP.Worksheet;

            int wkschildno = 4;
            SheetData Rows = (SheetData)Worksheet.ChildElements.GetItem(wkschildno);

            Row currentrow = (Row)Rows.ChildElements.GetItem(checkRow - 1);
            currentrow.Remove();
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

    public static int InsertRow(WorksheetPart worksheetPart)
    {
        SheetData sheetData = worksheetPart.Worksheet.GetFirstChild<SheetData>();
        Row lastRow = sheetData.Elements<Row>().LastOrDefault();

        if (lastRow != null)
        {
            sheetData.InsertAfter(new Row() { RowIndex = (lastRow.RowIndex + 1) }, lastRow);
            return (int)UInt32Value.ToUInt32(lastRow.RowIndex);
        }
        else
        {
            sheetData.InsertAt(new Row() { RowIndex = 0 }, 0);
            return 0;
        }
    }

    private static int InsertSharedStringItem(string text, SharedStringTablePart shareStringPart)
    {
        // If the part does not contain a SharedStringTable, create one.
        if (shareStringPart.SharedStringTable == null)
        {
            shareStringPart.SharedStringTable = new SharedStringTable();
        }

        int i = 0;

        // Iterate through all the items in the SharedStringTable. If the text already exists, return its index.
        foreach (SharedStringItem item in shareStringPart.SharedStringTable.Elements<SharedStringItem>())
        {
            if (item.InnerText == text)
            {
                return i;
            }

            i++;
        }

        // The text does not exist in the part. Create the SharedStringItem and return its index.
        shareStringPart.SharedStringTable.AppendChild(new SharedStringItem(new DocumentFormat.OpenXml.Spreadsheet.Text(text)));
        shareStringPart.SharedStringTable.Save();

        return i;
    }
}