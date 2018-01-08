using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Excel = Microsoft.Office.Interop.Excel;

/// <summary>
/// Summary description for BankExcelUtils
/// </summary>
public class BankExcelUtils
{
    
    private static Excel.Workbook MyBook = null;
    private static Excel.Application MyApp = null;
    private static Excel.Worksheet MySheet = null;
    private static int lastRow = null;

    public BankExcelUtils()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void AddToPendingChecks(System.Guid guid, string payto, string email, string AccountNumberOrMemo, double amount)
    {
        MyApp = new Excel.Application();
        MyApp.Visible = false;
        MyBook = MyApp.Workbooks.Open("billpay.xlsx");
        MySheet = (Excel.Worksheet)MyBook.Sheets[3]; // Explicit cast is not required here
        lastRow = MySheet.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell).Row;

        MySheet.Cells[lastRow, 1] = "Pending";
        MySheet.Cells[lastRow, 2] = guid;
        MySheet.Cells[lastRow, 3] = payto;
        MySheet.Cells[lastRow, 4] = email;
        MySheet.Cells[lastRow, 5] = AccountNumberOrMemo;
        MySheet.Cells[lastRow, 6] = DateTime.Now.ToString();
        MySheet.Cells[lastRow, 7] = amount;

        MyBook.Save();
    }
}