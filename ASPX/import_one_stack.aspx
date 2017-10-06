
<%@ Page Language="C#" Debug="true"  %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System.Web.Script.Serialization" %>

<script language="c#" runat="server">
    /*
      import_one_stack.aspx
      Version 10/5/2017
      Created by Sean Worthington
      Powns one stackfile
      Usage: https://cloudcoin.global/bank/import_one_stack.aspx
      This software is for use by CloudCoin Consortium Clients only. 
      All rights reserved.  


        Sample Response if good:

        {
         "bank_server":"CloudCoin.co",
         "status":"importing",
         "message":"The stack file has been imported and detection will begin automatically so long as they are not already in bank. Please check your reciept.",
         "reciept":"640322f6d30c45328914b441ac0f4e5b",
         "time":"2016-49-21 7:49:PM"
        }

        Sample Response if bad file bad:

        {
         "bank_server":"CloudCoin.co",
         "status":"Error",
         "message":"JSON: Your stack file was corrupted. Please check JSON validation.",
         "reciept":"640322f6d30c45328914b441ac0f4e5b",
         "time":"2016-49-21 7:49:PM"
        }

        Sample Response if nothing attached :

        {
         "bank_server":"CloudCoin.co",
         "status":"Error",
         "message":"LoadFile: The stack file was empty.",
         "reciept":"640322f6d30c45328914b441ac0f4e5b",
         "time":"2016-49-21 7:49:PM"
        }

        Sample Response if No RAIDA Connectivity :
        {
         "bank_server":"CloudCoin.co",
         "status":"Error",
         "message":"You do not have enought RAIDA to perform an import operation.",
         "reciept":"640322f6d30c45328914b441ac0f4e5b",
         "time":"2016-49-21 7:49:PM"
        }


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
        //Usage: http://192.168.1.4/service/echo.aspx
        //Response.Write("here");
        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
        response.status = "importing";
        response.time = DateTime.Now.ToString("yyyy-mm-dd h:mm:tt");
        response.version = "1.0";

        string stack = c.Request["stack"];

        //Check RAIDA Status
        int totalRAIDABad = 0;
        for (int i = 0; i < 25; i++)
        {
            if (RAIDA_Status.failsEcho[i])
            {
                totalRAIDABad += 1;
            }
        }
        if (totalRAIDABad > 8)
        {
            response.status = "importing;
                response.message="You do not have enought RAIDA to perform an import operation.");
            return;
        }

        //CHECK TO SEE IF THERE ARE UN DETECTED COINS IN THE SUSPECT FOLDER
        String[] suspectFileNames = new DirectoryInfo(fileUtils.suspectFolder).GetFiles().Select(o => o.Name).ToArray();//Get all files in suspect folder
        if (suspectFileNames.Length > 0)
        {
            multidetect(stack);
        } //end if there are files in the suspect folder that need to be imported


        //Import the new stack
        Importer importer = new Importer(fileUtils);
        if (!importer.importAll(stack))//Moves all CloudCoins from the Import folder into the Suspect folder. 
        {
            // No coins in import folder.");// "No coins in import folder.");
        }
        else
        {
            multidetect(stack);
            Grader myGrader = mew Grader();
            myGrader.gradeAll();

        }//end if coins to import

        //Send client the response
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();

    }//End Page Load


</script>
