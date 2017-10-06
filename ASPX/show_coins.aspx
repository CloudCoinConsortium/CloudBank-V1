<%@ Page Language="C#" Debug="false"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    /*
      show_coins.aspx
      Version 10/05/2017
      Created by Sean Worthington
      Get's the bank's coin totals
      Usage: https://cloudcoin.global/bank/show_coins.aspx
      This software is for use by CloudCoin Consortium Clients only. 
      All rights reserved.  
      {
         "bank_server":"CloudCoin.co",
         "status":"coins_shown",
         "ones":205,
         "fives":10,
         "twentyfives":105,
         "hundreds":1050,
         "twohundredfifties":98,
         "time":"2016-49-21 7:49:PM"
       }

      */

    public class ServiceResponse
    {
        public string bank_server;
        public string status;
        public string version;
        public int ones;
        public int fives;
        public int twentyfives;
        public int hundreds;
        public int twohundredfifties;
        public string time;
    }

    public void Page_Load(object sender, EventArgs e)
    {

        //Response.Write("here");
        ServiceResponse response = new ServiceResponse();
        response.bank_server = WebConfigurationManager.AppSettings["thisServerName"];
        response.status = "coins_shown";
        response.time = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        response.version = "1.0";
        FileUtils fileUtils = new FileUtils();

        Console.Out.WriteLine("");
        // This is for consol apps.
        Banker bank = new Banker(fileUtils);
        int[] bankTotals = bank.countCoins(fileUtils.bankFolder);
        int[] frackedTotals = bank.countCoins(fileUtils.frackedFolder);

       // totals = bankTotals[0] + frackedTotals[0];
        response.ones = bankTotals[1] + frackedTotals[1];
        response.fives = bankTotals[2] + frackedTotals[2];
        response.twentyfives = bankTotals[3] + frackedTotals[3];
        response.hundreds = bankTotals[4] + frackedTotals[4];
        response.twohundredfifties = bankTotals[5] + frackedTotals[5];


        //VALIDATE INPUT VARIABLES
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();





    }//End Page Load

</script>
