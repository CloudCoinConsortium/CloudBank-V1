<%@ Page Language="C#" Debug="false"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    /*
      print_welcome.aspx
      Version 9/27/2017
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
        //response.server = "www.mybank.com";
        response.status = "welcome";
        response.version = "1.0";
        response.time = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        response.message = message;
        

        //VALIDATE INPUT VARIABLES
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();





    }//End Page Load

</script>
