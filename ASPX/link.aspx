<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Net.Http" %>


<script language="c#" runat="server">

    public class ServiceResponse
    {
        public string bank_server;
        public string status;
        public string message;
        public string time;
    }

    public class TicketServiceResponse
    {
        public string server;
        public string status;
        public string sn;
        public string message;
        public string time;
    }

    public class LinkServicesResponse
    {
        public string code;
        public string status;
        public string message;
        public string time;
    }

    public class Stack
    {

    }

    public void Page_Load(object sender, EventArgs e)
    {

        Page_Load_Async().Wait();

    }

    string CheckParameter(string param)
    {
        if (Request[param] != null)
            return Request[param];
        else
            return "";
    }

    public async System.Threading.Tasks.Task Page_Load_Async()
    {
        ServiceResponse response = new ServiceResponse();

        string CollectibleID = CheckParameter("c_id");
        string RequestedDenomination = CheckParameter("dn");
        string RAIDAPassword = CheckParameter("password");
        string PrivateKey = CheckParameter("pk");
        int amount = 0;

        if(PrivateKey != WebConfigurationManager.AppSettings["root"])
        {
            response.status = "error";
            response.message="Request Error: Private Key is incorrect or blank";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        try
        {
            amount = Int32.Parse(RequestedDenomination);
        }
        catch (FormatException ex)
        {
            response.status = "error";
            response.message="Request Error: The Denomination is not a number";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        if (RAIDAPassword == "")
        {
            response.status = "error";
            response.message="Request Error: RAIDA Password not provided";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        if (CollectibleID == "")
        {
            response.status = "error";
            response.message="Request Error: Collectible ID not provided";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        if (!(amount == 1 || amount == 5 || amount == 25 || amount == 100 || amount == 250))
        {
            response.status = "error";
            response.message="Request Error: unsuported denomination specified";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        FileUtils fileUtils = FileUtils.GetInstance(HttpRuntime.AppDomainAppPath + @"\" + PrivateKey + @"\");
        Founders.Stack stack = new Founders.Stack();
        Banker bank = new Banker(fileUtils);
        int[] bankTotals = bank.countCoins(fileUtils.bankFolder);

        int OnesAvailable = bankTotals[1];
        int FivesAvailable = bankTotals[2];
        int TwentyFivesAvailable = bankTotals[3];
        int HunderdsAvailable = bankTotals[4];
        int TwoHundredFiftiesAvailable = bankTotals[5];

        int Ones = 0;
        int Fives = 0;
        int TwentyFives = 0;
        int Hundreds = 0;
        int TwoHundredFifties = 0;

        if (amount == 1)
        {
            if (OnesAvailable > 0)
            {
                Ones = 1;
            }
            else
            {
                response.status = "error";
                response.message="Request Error: Denomination specified is unavailable";
                var json = new JavaScriptSerializer().Serialize(response);
                Response.Write(json);
                Response.End();
            }

        }

        if (amount == 5)
        {
            if (FivesAvailable > 0)
            {
                Fives = 1;
            }
            else
            {
                response.status = "error";
                response.message="Request Error: Denomination specified is unavailable";
                var json = new JavaScriptSerializer().Serialize(response);
                Response.Write(json);
                Response.End();
            }

        }

        if (amount == 25)
        {
            if (TwentyFivesAvailable > 0)
            {
                TwentyFives = 1;
            }
            else
            {
                response.status = "error";
                response.message="Request Error: Denomination specified is unavailable";
                var json = new JavaScriptSerializer().Serialize(response);
                Response.Write(json);
                Response.End();
            }

        }

        if (amount == 100)
        {
            if (HunderdsAvailable > 0)
            {
                Hundreds = 1;
            }
            else
            {
                response.status = "error";
                response.message="Request Error: Denomination specified is unavailable";
                var json = new JavaScriptSerializer().Serialize(response);
                Response.Write(json);
                Response.End();
            }

        }

        if (amount == 250)
        {
            if (TwoHundredFiftiesAvailable > 0)
            {
                TwoHundredFifties = 1;
            }
            else
            {
                response.status = "error";
                response.message="Request Error: Denomination specified is unavailable";
                var json = new JavaScriptSerializer().Serialize(response);
                Response.Write(json);
                Response.End();
            }

        }

        Exporter exporter = new Exporter(fileUtils);
        string guid = Guid.NewGuid().ToString("N");
        exporter.writeJSONFile(Ones, Fives, TwentyFives, Hundreds, TwoHundredFifties, guid);
        string path = fileUtils.exportFolder + Path.DirectorySeparatorChar + amount + ".CloudCoins." + guid + ".stack";
        string StackString = "";
        using (StreamReader sr = File.OpenText(path))
        {
            while (!sr.EndOfStream)
            {
                StackString += sr.ReadLine();
            }
        }

        stack = fileUtils.loadManyCloudCoinFromJsonFile("", StackString);

        string an = stack.cc.FirstOrDefault().an.FirstOrDefault();
        string sn = stack.cc.FirstOrDefault().sn.ToString();


        HttpClient Cli = new HttpClient();
       
        
        var r = Cli.GetAsync("https://raida0.CloudCoin.global/service/get_ticket?nn=" + "1" + "&sn=" + sn + "&an=" + an + "&pan=" + an + "&denomination=" + RequestedDenomination).Result;
        string getResponse = await r.Content.ReadAsStringAsync();
        

        TicketServiceResponse tsr = JsonConvert.DeserializeObject<TicketServiceResponse>(getResponse);

        if (tsr.status == "fail")
        {
            response.status = "fail";
            response.message = "Failed to authenticate coin during linking process: " + tsr.message;
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("nn", "1"),
                                                            new KeyValuePair<string, string>("sn", sn),
                                                            new KeyValuePair<string, string>("c_id",CollectibleID),
                                                            new KeyValuePair<string, string>("password", RAIDAPassword),
                                                            new KeyValuePair<string, string>("message1", tsr.message)});

        var pr = Cli.PostAsync("https://raida.tech/link_template.php", formContent).Result;
        string postResponse = await pr.Content.ReadAsStringAsync();

        LinkServicesResponse lsr = JsonConvert.DeserializeObject<LinkServicesResponse>(postResponse);

        if (lsr.status == "fail")
        {
            response.status = "fail";
            response.message = lsr.message;
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }
        else
        {
            Response.Write(StackString);
            Response.End();
        }

    }

</script>
