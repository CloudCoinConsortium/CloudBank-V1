using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
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
    private static int lastRow = 0;

    public BankExcelUtils()
    {
        MyApp = new Excel.Application
        {
            Visible = false
        };
        MyBook = MyApp.Workbooks.Open("billpay.xlsx");
    }

    public void AddToPendingChecks(string guidout, string payto, string emailto, string memo, double amount, string signedby, string youremail, string othercontactinfo, int daysvalid)
    {
        MySheet = (Excel.Worksheet)MyBook.Sheets[3]; // Explicit cast is not required here
        lastRow = MySheet.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell).Row;

        MySheet.Cells[lastRow, 1] = "Pending";
        MySheet.Cells[lastRow, 2] = guidout;
        MySheet.Cells[lastRow, 3] = payto;
        MySheet.Cells[lastRow, 4] = emailto;
        MySheet.Cells[lastRow, 5] = memo;
        MySheet.Cells[lastRow, 6] = DateTime.Now.ToString();
        MySheet.Cells[lastRow, 7] = amount;
        MySheet.Cells[lastRow, 8] = signedby;
        MySheet.Cells[lastRow, 9] = youremail;
        MySheet.Cells[lastRow, 10] = othercontactinfo;



        MyBook.Save();
    }

    public int FindCheckRow(string guid)
    {
        MySheet = (Excel.Worksheet)MyBook.Sheets[3]; // Explicit cast is not required here
        lastRow = MySheet.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell).Row;
        int checkRow = 0;
        int x;
        for (x = 1; x <= lastRow; x++)
        {
            if (MySheet.Cells[x, 2].ToString() == guid)
            {
                checkRow = x;
                break;
            }
        }
        return checkRow;
    }

    public void MarkCheckPaid(int checkRow)
    {
        MySheet = (Excel.Worksheet)MyBook.Sheets[3];
        string guid = MySheet.Cells[checkRow, 2].ToString();
        string payto = MySheet.Cells[checkRow, 3].ToString();
        string email = MySheet.Cells[checkRow, 4].ToString();
        string AccountNumberOrMemo = MySheet.Cells[checkRow, 5].ToString();
        double amount = (double)MySheet.Cells[checkRow, 7];

        MySheet = (Excel.Worksheet)MyBook.Sheets[4];
        lastRow = MySheet.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell).Row;


        MySheet.Cells[lastRow, 1] = guid;
        MySheet.Cells[lastRow, 2] = payto;
        MySheet.Cells[lastRow, 3] = email;
        MySheet.Cells[lastRow, 4] = AccountNumberOrMemo;
        MySheet.Cells[lastRow, 5] = DateTime.Now.ToString();
        MySheet.Cells[lastRow, 6] = amount;

        MyBook.Save();
    }

    public void DeleteFromPending(int checkRow)
    {
        MySheet = (Excel.Worksheet) MyBook.Sheets[3];

        ((Excel.Range)MySheet.Rows[checkRow, 0]).Delete(Excel.XlDeleteShiftDirection.xlShiftUp);
    }


}