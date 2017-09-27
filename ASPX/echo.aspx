<%@ Page Language="C#" Debug="false"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    /*
      print_welcome.aspx
      Version 9/28/2017
      Created by Navraj Singh
      Get's the bank's welcome information
      Usage: https://cloudcoin.global/bank/print_welcome.aspx
      This software is for use by CloudCoin Consortium Clients only. 
      All rights reserved.  
      */

    public class ServiceResponse
    {
        public string server;
        public string status;
        public string version;
        public string message;
        public string time;

    }

    public void Page_Load(object sender, EventArgs e)
    {
        //Usage: http://192.168.1.4/service/print_welcome.aspx
        string servername = WebConfigurationManager.AppSettings["thisServerName"];
        string date = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        string message = "CloudCoin Bank. Used to Authenticate, Store and Payout CloudCoins." +
                "This Software is provided as is with all faults, defects and errors, and without warranty of any kind." +
                "Free from the CloudCoin Consortium.";
        //Response.Write("here");
        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
        response.server = "www.mybank.com";
        response.status = "welcome";
        response.time = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        response.message = message;
        response.version = "1.0";

        bool res = echoRaida();
        if (res)
            response.message = "ready";
        else
            response.message = "fail";
        //VALIDATE INPUT VARIABLES
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();





    }//End Page Load

    public  bool echoRaida()
    {
        RAIDA_Status.resetEcho();
        RAIDA raida1 = new RAIDA(5000);
        Response[] results = raida1.echoAll(5000);
        int totalReady = 0;
        Console.Out.WriteLine("");
        //For every RAIDA check its results
        int longestCountryName = 15;

        Console.Out.WriteLine();
        for (int i = 0; i < 25; i++)
        {
            int padding = longestCountryName - RAIDA.countries[i].Length;
            string strPad = "";
            for (int j = 0; j < padding; j++)
            {
                strPad += " ";
            }//end for padding
             // Console.Out.Write(RAIDA_Status.failsEcho[i]);
            if (RAIDA_Status.failsEcho[i])
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.Out.Write(strPad + RAIDA.countries[i]);
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.Out.Write(strPad + RAIDA.countries[i]);
                totalReady++;
            }
            if (i == 4 || i == 9 || i == 14 || i == 19) { Console.WriteLine(); }
        }//end for
        Console.ForegroundColor = ConsoleColor.White;
        Console.Out.WriteLine("");
        Console.Out.WriteLine("");
        Console.Out.Write("  RAIDA Health: " + totalReady + " / 25: ");//"RAIDA Health: " + totalReady );

        //Check if enough are good 
        if (totalReady < 16)//
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.Out.WriteLine("  Not enough RAIDA servers can be contacted to import new coins.");// );
            Console.Out.WriteLine("  Is your device connected to the Internet?");// );
            Console.Out.WriteLine("  Is a router blocking your connection?");// );
            Console.ForegroundColor = ConsoleColor.White;
            return false;
        }
        else
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.Out.WriteLine("The RAIDA is ready for counterfeit detection.");// );
            Console.ForegroundColor = ConsoleColor.White;
            return true;
        }//end if enough RAIDA
    }//End echo

</script>
