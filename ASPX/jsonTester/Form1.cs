﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net;
using System.IO;
using Newtonsoft.Json;

namespace jsonTester
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private async void SubmitJsonButton_Click(object sender, EventArgs e)
        {
            string CloudBankFeedback = "";
            string rawJson = jsonInputTextBox.Text;
            var formContent = new FormUrlEncodedContent(new[] { new KeyValuePair<string, string>("stack", rawJson) });

            HttpClient cli = new HttpClient();

            try
            {
                var result_stack = await cli.PostAsync(urlTextBox.Text, formContent);
                CloudBankFeedback = await result_stack.Content.ReadAsStringAsync();
            }
            catch (Exception ex)
            {
                Console.Out.WriteLine(ex.Message);
            }

            jsonOutputTextBox.Text = CloudBankFeedback; 
        }
    }
}