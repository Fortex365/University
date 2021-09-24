namespace WindowsFormsApp1
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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.O_PrintButton = new System.Windows.Forms.Button();
            this.I_Name = new System.Windows.Forms.TextBox();
            this.I_City = new System.Windows.Forms.TextBox();
            this.I_ZIPCODE = new System.Windows.Forms.TextBox();
            this.I_Street = new System.Windows.Forms.TextBox();
            this.Output = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(163, 99);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(35, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Name";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(163, 131);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(35, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Street";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(163, 160);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(46, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Zipcode";
            this.label3.Click += new System.EventHandler(this.label3_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(174, 183);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(24, 13);
            this.label4.TabIndex = 3;
            this.label4.Text = "City";
            // 
            // O_PrintButton
            // 
            this.O_PrintButton.Location = new System.Drawing.Point(215, 209);
            this.O_PrintButton.Name = "O_PrintButton";
            this.O_PrintButton.Size = new System.Drawing.Size(75, 23);
            this.O_PrintButton.TabIndex = 4;
            this.O_PrintButton.Text = "Print";
            this.O_PrintButton.UseVisualStyleBackColor = true;
            this.O_PrintButton.Click += new System.EventHandler(this.O_PrintButton_Click);
            // 
            // I_Name
            // 
            this.I_Name.Location = new System.Drawing.Point(215, 92);
            this.I_Name.Name = "I_Name";
            this.I_Name.Size = new System.Drawing.Size(100, 20);
            this.I_Name.TabIndex = 5;
            // 
            // I_City
            // 
            this.I_City.Location = new System.Drawing.Point(215, 183);
            this.I_City.Name = "I_City";
            this.I_City.Size = new System.Drawing.Size(100, 20);
            this.I_City.TabIndex = 6;
            this.I_City.TextChanged += new System.EventHandler(this.textBox2_TextChanged);
            // 
            // I_ZIPCODE
            // 
            this.I_ZIPCODE.Location = new System.Drawing.Point(215, 157);
            this.I_ZIPCODE.Name = "I_ZIPCODE";
            this.I_ZIPCODE.Size = new System.Drawing.Size(100, 20);
            this.I_ZIPCODE.TabIndex = 7;
            this.I_ZIPCODE.TextChanged += new System.EventHandler(this.textBox3_TextChanged);
            // 
            // I_Street
            // 
            this.I_Street.Location = new System.Drawing.Point(215, 124);
            this.I_Street.Name = "I_Street";
            this.I_Street.Size = new System.Drawing.Size(100, 20);
            this.I_Street.TabIndex = 8;
            this.I_Street.TextChanged += new System.EventHandler(this.textBox4_TextChanged);
            // 
            // Output
            // 
            this.Output.AutoSize = true;
            this.Output.Location = new System.Drawing.Point(174, 240);
            this.Output.Name = "Output";
            this.Output.Size = new System.Drawing.Size(0, 13);
            this.Output.TabIndex = 9;
            this.Output.Click += new System.EventHandler(this.label5_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.Output);
            this.Controls.Add(this.I_Street);
            this.Controls.Add(this.I_ZIPCODE);
            this.Controls.Add(this.I_City);
            this.Controls.Add(this.I_Name);
            this.Controls.Add(this.O_PrintButton);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button O_PrintButton;
        private System.Windows.Forms.TextBox I_Name;
        private System.Windows.Forms.TextBox I_City;
        private System.Windows.Forms.TextBox I_ZIPCODE;
        private System.Windows.Forms.TextBox I_Street;
        private System.Windows.Forms.Label Output;
    }
}

