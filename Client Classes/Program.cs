using System;
using banktesterforms;
using System.Threading.Tasks;
using System.Net.Http;

namespace CloudBankTester
{
    class Program
    {

        /* INSTANCE VARIABLES */
        public static KeyboardReader reader = new KeyboardReader();
        //  public static String rootFolder = System.getProperty("user.dir") + File.separator +"bank" + File.separator ;
        public static String rootFolder = AppDomain.CurrentDomain.BaseDirectory;
        public static String prompt = "Start Mode> ";
        public static String[] commandsAvailable = new String[] { "Load Bank Keys", "Show Coins", "Deposite Coin", "Withdraw Coins","Look at Receipt", "Write Check","Get Check", "quit" };
   //public static int timeout = 10000; // Milliseconds to wait until the request is ended. 
       // public static FileUtils fileUtils = new FileUtils(rootFolder, bank);
        public static Random myRandom = new Random();
        public static string publicKey = "";
        public static string privateKey = "";
        public static string email = "";
        public static string sign = "Preston Linderman";
        public static BankKeys myKeys;
        private static CloudBankUtils receiptHolder;
        private static HttpClient cli = new HttpClient();




        /* MAIN METHOD */
        public static void Main(String[] args)
        {
            printWelcome();
            run().Wait(); // Makes all commands available and loops
            Console.Out.WriteLine("Thank you for using CloudBank Tester. Goodbye.");
        } // End main

        /* STATIC METHODS */
        public static async Task run()
        {
            bool restart = false;
            while (!restart)
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.Out.WriteLine("");
                //  Console.Out.WriteLine("========================================");
                Console.Out.WriteLine("");
                Console.Out.WriteLine("Commands Available:");
                Console.ForegroundColor = ConsoleColor.White;
                int commandCounter = 1;
                foreach (String command in commandsAvailable)
                {
                    Console.Out.WriteLine(commandCounter + (". " + command));
                    commandCounter++;
                }
                Console.ForegroundColor = ConsoleColor.Green;
                Console.Out.Write(prompt);
                Console.ForegroundColor = ConsoleColor.White;
                int commandRecieved = reader.readInt(1,6);


                switch (commandRecieved)
                {
                    case 1:
                        loadKeys();
                        break;
                    case 2:
                        await showCoins();
                        break;
                    case 3:
                        receiptHolder = await depositAsync();
                        break;
                    case 4:
                        await withdraw();
                        break;
                    case 5:
                        receipt();
                        break;
                    case 6:
                        await writeCheck();
                        break;
                    case 7:
                        await GetCheck();
                        break;
                    case 8:
                        Console.Out.WriteLine("Goodbye!");
                        Environment.Exit(0);
                        break;
                    default:
                        Console.Out.WriteLine("Command failed. Try again.");
                        break;
                }// end switch
            }// end while
        }// end run method


        public static void printWelcome()
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.Out.WriteLine("╔══════════════════════════════════════════════════════════════════╗");
            Console.Out.WriteLine("║                   CloudBank Tester v.11.19.17                    ║");
            Console.Out.WriteLine("║          Used to Authenticate Test CloudBank                     ║");
            Console.Out.WriteLine("║      This Software is provided as is with all faults, defects    ║");
            Console.Out.WriteLine("║          and errors, and without warranty of any kind.           ║");
            Console.Out.WriteLine("║                Free from the CloudCoin Consortium.               ║");
            Console.Out.WriteLine("╚══════════════════════════════════════════════════════════════════╝");
            Console.ForegroundColor = ConsoleColor.White;
        } // End print welcome



        static void loadKeys()
        {
            publicKey = "Preston.CloudCoin.global";
            privateKey = "0DECE3AF-43EC-435B-8C39-E2A5D0EA8676";
            email = "Preston@ChicoHolo.com";
            Console.Out.WriteLine("Public key is " + publicKey );
            Console.Out.WriteLine("Private key is " + privateKey);
            Console.Out.WriteLine("Email is " + email);
            myKeys = new BankKeys(publicKey, privateKey, email);
        }

        /* Show coins will populate the CloudBankUtils with the totals of each denominations
         These totals are public properties that can be accessed */
        static async Task showCoins()
        {
            CloudBankUtils cbu = new CloudBankUtils(myKeys);
            await cbu.showCoins();
            Console.Out.WriteLine("Ones in our bank:" + cbu.onesInBank  );
            Console.Out.WriteLine("Five in our bank:" + cbu.fivesInBank);
            Console.Out.WriteLine("Twenty Fives in our bank:" + cbu.twentyFivesInBank);
            Console.Out.WriteLine("Hundreds in our bank:" + cbu.hundresInBank );
            Console.Out.WriteLine("Two Hundred Fifties in our bank:" + cbu.twohundredfiftiesInBank );
        }//end show coins


        /* Deposit allow you to send a stack file to the CloudBank */
        static async Task<CloudBankUtils> depositAsync()
        {
            CloudBankUtils sender = new CloudBankUtils( myKeys);
            Console.Out.WriteLine("What is the path to your stack file?");
            //string path = reader.readString();
            string path = AppDomain.CurrentDomain.BaseDirectory ;
            path += reader.readString();
            Console.Out.WriteLine("Loading " + path);
            sender.loadStackFromFile(path);
            await sender.sendStackToCloudBank(publicKey);
            await sender.getReceipt(publicKey);
            return sender;
        }//end deposit


        static async Task withdraw()
        {
            CloudBankUtils receiver;
            if (receiptHolder == null)
                receiver = new CloudBankUtils(myKeys);
            else
                receiver = receiptHolder;

            Console.Out.WriteLine("How many CloudCoins are you withdrawing?");
            int amount = reader.readInt();
            await receiver.getStackFromCloudBank(amount);
            receiver.saveStackToFile(AppDomain.CurrentDomain.BaseDirectory);
        }//end deposit
        static void receipt()
        {
            if (receiptHolder == null)
                Console.Out.WriteLine("There has not been a recent deposit. So no receipt can be shown.");
            else
                Console.Out.WriteLine(receiptHolder.interpretReceipt());
        }//end deposit

        static async Task writeCheck()
        {
            Console.Out.WriteLine("How many CloudCoins are you withdrawing?");
            int amount = reader.readInt();
            Console.Out.WriteLine("Who are you Paying?");
            string payto = reader.readString();
            Console.Out.WriteLine("Who is being Emailed?");
            string emailto = reader.readString();
            var request = await cli.GetAsync("https://"+publicKey+"/write_check.aspx?pk=" + privateKey + "&action=email&amount="+amount+"&emailto="+emailto+"&payto="+payto+"&from="+email+"&signby="+sign);
            string response = await request.Content.ReadAsStringAsync();
            Console.Out.WriteLine(response);
        }

        static async Task GetCheck()
        {
            Console.Out.WriteLine("What is the Check's Id?");
            string id = reader.readString();
            var request = await cli.GetAsync("https://" + publicKey + "/checks.aspx?id="+id+"&receive=json");
            string response = await request.Content.ReadAsStringAsync();
            Console.Out.WriteLine(response);
        }
    }
}
