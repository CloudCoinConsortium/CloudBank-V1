<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading.Tasks" %>

<script language="c#" runat="server">
    /*
      echo.aspx
      Version 10/5/2017
      Created by Navraj Singh
      Get's the bank's welcome information
      Usage: https://cloudcoin.global/bank/echo.aspx
      This software is for use by CloudCoin Consortium Clients only. 
      All rights reserved.  
      
      SAMPLE RESPONSE READY
      {
        "bank_server":"CloudCoin.co",
        "status":"ready",
        "message":"The RAIDA is ready for counterfeit detection.",
        "time":"2016-49-21 7:49:PM"
        }
        
       SAMPLE RESPONSE IF No READY 
        {
            "bank_server":"CloudCoin.co",
            "status":"fail",
            "message":"Not enough RAIDA servers can be contacted to import new coins.",
            "time":"2016-49-21 7:49:PM"
       }
      */

    public class ServiceResponse
    {
        public string bank_server;
        public string status;
        public string version;
        public string message;
        public string time;
    }//End Service Response class

    public void Page_Load(object sender, EventArgs e)
    {
        //Usage: http://192.168.1.4/service/echo.aspx
        //Response.Write("here");


        RegisterAsyncTask(new PageAsyncTask(echoStatus));
        //VALIDATE INPUT VARIABLES

    }//End Page Load

    public async Task echoStatus()
    {
        ServiceResponse response = new ServiceResponse();
        response.bank_server = WebConfigurationManager.AppSettings["thisServerName"];
        response.status = "ready";
        response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");
        response.version = "1.0";

        bool echo = await echoRaida();
        if (echo)
        {
            response.status = "ready";
            response.message = "The RAIDA is ready for counterfeit detection.";
        }
        else
        {
            response.status = "fail";
            response.message = "Not enough RAIDA servers can be contacted to import new coins.";
        }

        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();
    }


    public async Task<bool> echoRaida()
    {
        RAIDA_Status.resetEcho();

        RAIDA raida1 = new RAIDA();

        await raida1.echoAll(5000);

        int totalReady = 0;

        for (int i = 0; i < 25; i++)
        {
            if (RAIDA_Status.failsEcho[i])
            {
                //Not ready. Do not add

            }
            else
            {
                totalReady++;

            }
        }//end for

        //Check if enough are good 
        if (totalReady < 16)//
        {
            return false;
        }
        else
        {
            return true;
        }//end if enough RAIDA
    }//End echo

</script>
