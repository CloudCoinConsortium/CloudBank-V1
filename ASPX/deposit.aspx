<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Threading.Tasks" %>


<script language="c#" runat="server">
    /*
      deposit.aspx
      Version 10/21/2017
      Created by Sean H. Worthington
      Recieves a stack file and an rn (receipt number) from the client and starts importing. Will return a status of "importing" or "error." 
      Usage: https://cloudcoin.global/service/deposit?rn=B78663C4E328CD643151AE238566B121
      This software is MIT licence. 
      */



    public class ServiceResponse
    {
        public string server;
        public string status;
        public string receipt;
        public string message;
        public string time;
    }//End Service Response class

    static FileUtils fileUtils = FileUtils.GetInstance(AppDomain.CurrentDomain.BaseDirectory);

    public void Page_Load(object sender, EventArgs e)
    {
        string rn = Request.QueryString["rn"];
        string stack = Request.Form["stack"];
        Importer importer = new Importer(fileUtils);
        bool import = false;
        if (stack != null)
            import = importer.importJson(stack);
        if (!import)//Moves all CloudCoins from the Import folder into the Suspect folder. 
        {
            ServiceResponse response = new ServiceResponse();
            response.server = WebConfigurationManager.AppSettings["thisServerName"];
            response.status = "error";
            response.message = "The CloudCoin stack was either empty or the JSON was not valid.";
            response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");
            response.receipt = "";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();

        }
        else
        {
            RegisterAsyncTask(new PageAsyncTask(detect));

        }//end if coins to import

        
    }//End Page Load

    private async Task detect(rn)
    {
        string receiptFileName = await multi_detect(rn);
        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
        response.receipt = receiptFileName;
        response.status = "importing";
        response.message = "The stack file has been imported and detection will begin automatically so long as they are not already in bank. Please check your reciept.";
        response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");
        Grader grader = new Grader(fileUtils);
        int[] detectionResults = grader.gradeAll(5000, 2000, receiptFileName);
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();
    }

    public static async Task<string> multi_detect() {

        MultiDetect multi_detector = new MultiDetect(fileUtils);
        string receiptFileName;
        using (var rng = RandomNumberGenerator.Create())
        {
            byte[] cryptoRandomBuffer = new byte[16];
            rng.GetBytes(cryptoRandomBuffer);

            Guid pan = new Guid(cryptoRandomBuffer);
            receiptFileName = pan.ToString("N");
        }

        //Calculate timeout
        int detectTime = 20000;
        if (RAIDA_Status.getLowest21() > detectTime)
        {
            detectTime = RAIDA_Status.getLowest21() + 200;
        }//Slow connection

        await multi_detector.detectMulti(detectTime, receiptFileName);
        return receiptFileName;
    }//end multi detect

</script>
