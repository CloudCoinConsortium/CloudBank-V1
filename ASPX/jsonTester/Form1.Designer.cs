namespace jsonTester
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.urlTextBox = new System.Windows.Forms.TextBox();
            this.jsonInputTextBox = new System.Windows.Forms.TextBox();
            this.jsonOutputTextBox = new System.Windows.Forms.TextBox();
            this.SubmitJsonButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // urlTextBox
            // 
            this.urlTextBox.Location = new System.Drawing.Point(36, 29);
            this.urlTextBox.Name = "urlTextBox";
            this.urlTextBox.Size = new System.Drawing.Size(899, 20);
            this.urlTextBox.TabIndex = 0;
            // 
            // jsonInputTextBox
            // 
            this.jsonInputTextBox.Location = new System.Drawing.Point(36, 67);
            this.jsonInputTextBox.Multiline = true;
            this.jsonInputTextBox.Name = "jsonInputTextBox";
            this.jsonInputTextBox.Size = new System.Drawing.Size(899, 222);
            this.jsonInputTextBox.TabIndex = 1;
            // 
            // jsonOutputTextBox
            // 
            this.jsonOutputTextBox.Location = new System.Drawing.Point(36, 309);
            this.jsonOutputTextBox.Multiline = true;
            this.jsonOutputTextBox.Name = "jsonOutputTextBox";
            this.jsonOutputTextBox.Size = new System.Drawing.Size(899, 222);
            this.jsonOutputTextBox.TabIndex = 2;
            // 
            // SubmitJsonButton
            // 
            this.SubmitJsonButton.Location = new System.Drawing.Point(405, 562);
            this.SubmitJsonButton.Name = "SubmitJsonButton";
            this.SubmitJsonButton.Size = new System.Drawing.Size(120, 39);
            this.SubmitJsonButton.TabIndex = 3;
            this.SubmitJsonButton.Text = "Submit Json";
            this.SubmitJsonButton.UseVisualStyleBackColor = true;
            this.SubmitJsonButton.Click += new System.EventHandler(this.SubmitJsonButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(983, 631);
            this.Controls.Add(this.SubmitJsonButton);
            this.Controls.Add(this.jsonOutputTextBox);
            this.Controls.Add(this.jsonInputTextBox);
            this.Controls.Add(this.urlTextBox);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox urlTextBox;
        private System.Windows.Forms.TextBox jsonInputTextBox;
        private System.Windows.Forms.TextBox jsonOutputTextBox;
        private System.Windows.Forms.Button SubmitJsonButton;
    }
}

