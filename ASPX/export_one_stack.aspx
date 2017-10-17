<%@ Page Language="C#" Debug="true"  Async="true"%>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import namespace="System.Data.SqlClient" %>
<%@ Import namespace="System.Web.Configuration" %>
<%@ Import namespace="Founders" %>
<%@ Import namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Security.Cryptography" %>



<script language="c#" runat="server">



    static FileUtils fileUtils = FileUtils.GetInstance(AppDomain.CurrentDomain.BaseDirectory);

    public void Page_Load(object sender, EventArgs e)
    {

        int amount = 0;
        int total = 0;

        try
        {
            amount = Int32.Parse(Request["amount"]);
            total = amount;

        } catch(FormatException ex)
        {
            Console.Out.WriteLine(ex);
            Response.Write("Request Error: The Amount isn't a number");
            Response.End();
        } catch(ArgumentNullException n)
        {
            Console.Out.WriteLine(n);
            Response.Write("Request Error: Ammunt of CloudCoins not specified");
            Response.End();
        }

        if(amount == 0)
        {
            Response.Write("Request Error: Ammunt of CloudCoins not specified");
            Response.End();
        }
        else
        {
            string tag = "";
            if (Request["tag"] != null)
                tag = Request["tag"];
            using (var rng = RandomNumberGenerator.Create())
            {
                byte[] cryptoRandomBuffer = new byte[16];
                rng.GetBytes(cryptoRandomBuffer);
                Guid guid = new Guid(cryptoRandomBuffer);
                tag += guid.ToString("N");
            }
            Founders.Stack response = new Founders.Stack();
            Banker bank = new Banker(fileUtils);
            int[] bankTotals = bank.countCoins(fileUtils.bankFolder);
            int[] frackedTotals = bank.countCoins(fileUtils.frackedFolder);
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
            string json = "";
            using (StreamReader sr = File.OpenText(path))
            {

                while (!sr.EndOfStream)
                {
                    json += sr.ReadLine();
                }
            }
            Response.Write(json);
            Response.End();
        }
    }

    </script>