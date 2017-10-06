
<%@ Page Language="C#" Debug="false"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    /*
      export_one_stack.aspx
      Version 10/05/2017
      Created by Sean Worthington
      Get's the bank's welcome information
      Usage: https://cloudcoin.global/bank/ export_one_stack.aspx?tag=MyMessageHere&amount=250
      This software is for use by CloudCoin Consortium Clients only. 
      All rights reserved.  
      */


    public void Page_Load(object sender, EventArgs e)
    {


        Console.Out.WriteLine("");
        Banker bank = new Banker(fileUtils);
        int[] bankTotals = bank.countCoins(fileUtils.bankFolder);
        int[] frackedTotals = bank.countCoins(fileUtils.frackedFolder);

        Console.Out.WriteLine("  Your Bank Inventory:");
        int grandTotal = (bankTotals[0] + frackedTotals[0] + partialTotals[0]);


        //Do not export more than 1000 notes at one time???
        // move to export

        Exporter exporter = new Exporter(fileUtils);
        string stack = exporter.getStack();
       

            exporter.writeJSONFile(exp_1, exp_5, exp_25, exp_100, exp_250, tag);



        //VALIDATE INPUT VARIABLES
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();





    }//End Page Load

</script>
