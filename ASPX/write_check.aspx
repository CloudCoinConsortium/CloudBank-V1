<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Security.Cryptography" %>

<%@ Import Namespace="System.Net.Mail" %>



<script language="c#" runat="server">



    //static string path = WebConfigurationManager.AppSettings["root"];
    //static FileUtils fileUtils = FileUtils.GetInstance(@"H:\Banks\Preston\"+path+@"\");
    //FileUtils fileUtils = FileUtils.GetInstance(HttpRuntime.AppDomainAppPath.ToString() + @"\" + path + @"\");



    public class ServiceResponse
    {
        public string server;
        public string status;

        public string message;
        public string time;
    }//End Service Response class

    public void Page_Load(object sender, EventArgs e)
    {
        string pk = Page.Request.Form["pk"];
        FileUtils fileUtils = FileUtils.GetInstance(HttpRuntime.AppDomainAppPath.ToString() + @"\" + pk + @"\");


        ServiceResponse response = new ServiceResponse();
        response.server = WebConfigurationManager.AppSettings["thisServerName"];
        //response.server = "Preston.CloudCoin.global";

        response.time = DateTime.Now.ToString("yyyy-MM-dd h:mm:tt");
        int amount = 0;
        int total = 0;
        string action = "";

        if(Request["pk"] != WebConfigurationManager.AppSettings["root"])
        {
            response.status = "error";
            response.message="Request Error: Private Key is Wrong";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        try
        {
            amount = Int32.Parse(Request["amount"]);
            total = amount;

        } catch(FormatException ex)
        {
            Console.Out.WriteLine(ex);
            response.status = "error";
            response.message="Request Error: The Amount isn't a number";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        } catch(ArgumentNullException n)
        {
            Console.Out.WriteLine(n);
            response.status = "error";
            response.message="Request Error: Amount of CloudCoins not specified";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        try
        {
            action = Request["action"];
        } catch(ArgumentNullException n)
        {
            Console.Out.WriteLine(n);
            response.status = "error";
            response.message="Request Error: No action specified";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }

        if(amount == 0)
        {
            response.status = "error";
            response.message="Request Error: Amount of CloudCoins not specified";
            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();
        }
        else
        {
            System.Guid guidout;
            string tag = "";
            //create guid for check id
            using (var rng = RandomNumberGenerator.Create())
            {
                byte[] cryptoRandomBuffer = new byte[16];
                rng.GetBytes(cryptoRandomBuffer);
                Guid guid = new Guid(cryptoRandomBuffer);
                guidout = guid;
                tag += guid.ToString("N");
            }
            //check if the bank holds enough coins
            Banker bank = new Banker(fileUtils);
            int[] bankTotals = bank.countCoins(fileUtils.bankFolder);
            int[] frackedTotals = bank.countCoins(fileUtils.frackedFolder);
            if(bankTotals[0] + frackedTotals[0] < amount)
            {
                response.status = "error";
                response.message="Not enough funds to write Check for "+amount+" CloudCoins";
                var ejson = new JavaScriptSerializer().Serialize(response);
                Response.Write(ejson);
                Response.End();
            }
            //write check body
            string emailto = CheckParameter("emailto");
            string payto = CheckParameter("payto");
            string from = CheckParameter("from");
            string signby = CheckParameter("signby");
            string memo = CheckParameter("memo");
            string othercontactinfo = CheckParameter("othercontactinfo");

            string link = "https://Preston.Cloudcoin.global/checks/" + tag + ".html";

            string CheckHtml = "<html><body><h1>" + signby + "</h1><email>" + from + "</email><h2>PAYTO THE ORDER OF: " + payto + "</h2><h2>AMOUNT: " + amount + " CloudCoins</h2>"
                + "<a href='https://Preston.Cloudcoin.global/checks.aspx?id="+tag+"'>Cash Check Now</a></body></html>";

            using (StreamWriter sw = File.AppendText(fileUtils.rootFolder + Path.DirectorySeparatorChar + "Checks" + Path.DirectorySeparatorChar + tag +".html"))
            {

                sw.WriteLine(CheckHtml);

            }
            //send email
            SmtpClient cli = new SmtpClient();
            MailAddress MAfrom = new MailAddress(from);
            MailAddress to = new MailAddress(emailto);
            MailMessage message = new MailMessage(MAfrom, to);
            message.Body = link;
            message.Subject = "Check for" + amount + " CloudCoins";

            cli.SendAsync(message, "CloudBank Check");

            //update spreadsheet


            response.status = "emailed";
            response.message="Check sent to "+emailto+" for "+amount+" CloudCoins";

            //create check's stack file
            int exp_1 = 0;
            int exp_5 = 0;
            int exp_25 = 0;
            int exp_100 = 0;
            int exp_250 = 0;
            if(amount > 250 && bankTotals[5] + frackedTotals[5] > 0)
            {
                exp_250 = ((amount / 250) < (bankTotals[5] + frackedTotals[5] )) ? (amount / 250) : (bankTotals[5] + frackedTotals[5]);
                amount -= (exp_250 * 250);
            }
            if(amount > 100 && bankTotals[4] + frackedTotals[4] > 0)
            {
                exp_100 = ((amount / 100) < (bankTotals[4] + frackedTotals[4]) ) ? (amount / 100) : (bankTotals[4] + frackedTotals[4]);
                amount -= (exp_100 * 100);
            }
            if(amount > 25 && bankTotals[3] + frackedTotals[3] > 0)
            {
                exp_25 = ((amount / 25) < (bankTotals[3] + frackedTotals[3]) ) ? (amount / 25) : (bankTotals[3] + frackedTotals[3]);
                amount -= (exp_25 * 25);
            }
            if(amount > 5 && bankTotals[2] + frackedTotals[2] > 0)
            {
                exp_5 = ((amount / 5) < (bankTotals[2] + frackedTotals[2]) ) ? (amount / 5) : (bankTotals[2] + frackedTotals[2]);
                amount -= (exp_5 * 5);
            }
            if(amount > 1 && bankTotals[1] + frackedTotals[1] > 0)
            {
                exp_1 = (amount  < (bankTotals[1] + frackedTotals[1]) ) ? amount  : (bankTotals[1] + frackedTotals[1]);
                amount -= (exp_1);
            }
            Exporter exporter = new Exporter(fileUtils);
            exporter.writeJSONFile(exp_1, exp_5, exp_25, exp_100, exp_250, tag);
            string path = fileUtils.exportFolder + Path.DirectorySeparatorChar + total + ".CloudCoins." + tag + ".stack";
            string check_path = fileUtils.rootFolder + Path.DirectorySeparatorChar + "Checks" + Path.DirectorySeparatorChar +  "CloudCoins." + tag + ".stack";
            File.Move(path, check_path);


            var json = new JavaScriptSerializer().Serialize(response);
            Response.Write(json);
            Response.End();

            BankExcelUtils bxu = new BankExcelUtils();

            //bxu.AddToPendingChecks(guidout, payto, emailto, memo, amount);
            bxu.AddToPendingChecks(payto, emailto, memo, amount, signby, from, othercontactinfo, 180);

        }


    }

    string CheckParameter(string param)
    {
        if (Request[param] != null)
            return Request[param];
        else
            return "";
    }



    </script>