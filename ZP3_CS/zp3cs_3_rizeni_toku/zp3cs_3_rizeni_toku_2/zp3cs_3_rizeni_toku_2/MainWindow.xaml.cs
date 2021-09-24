using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace zp3cs_3_rizeni_toku_2
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void btnKopirovat_Click(object sender, RoutedEventArgs e)
        {
            txtKopie.Text = ""; 
            string odkud = txtZdroj.Text;
            for (int i = 0; i != odkud.Length; i++)
                txtKopie.Text += kopirujZnak(odkud[i]);
        }
        private string kopirujZnak(char znak) 
        { 
            switch (znak) 
            { 
                case '<': 
                    return "&lt;"; 
                case '>': 
                    return "&gt;"; 
                case '&':
                    return "&amp;";
                case '\"': 
                    return "&#34;"; 
                case '\'': 
                    return "&#39;";
                default:
                    return znak.ToString();
            } 
        }


    }
}
