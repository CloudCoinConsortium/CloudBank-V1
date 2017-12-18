<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Threading.Tasks" %>


<script language="c#" runat="server">

    public class ServiceResponse
    {
        public string server;
        public string status;
        public string receipt;
        public string message;
        public string time;
    }//End Service Response class

	static string path = WebConfigurationManager.AppSettings["root"];
	//static string path1 = Directory.GetCurrentDirectory();
  //  static FileUtils fileUtils = FileUtils.GetInstance(path1+path+@"\");
    
	static FileUtils fileUtils = FileUtils.GetInstance(AppDomain.CurrentDomain.BaseDirectory +path+@"\" );


    public void Page_Load(object sender, EventArgs e)
    {
	
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
        //    response.message = stack;
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





    private async Task detect()
    {
        string receiptFileName = await multi_detect();
        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
        response.receipt = receiptFileName;
        response.status = "importing";
        response.message = "The stack file has been imported and detection will begin automatically so long as they are not already in bank. Please check your receipt.";
        response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");
        Grader grader = new Grader(fileUtils);
        int[] detectionResults = grader.gradeAll(5000, 2000, receiptFileName);
        var json = new JavaScriptSerializer().Serialize(response);
        Response.Write(json);
        Response.End();
    }




    public static async Task<string> multi_detect() 
    {

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