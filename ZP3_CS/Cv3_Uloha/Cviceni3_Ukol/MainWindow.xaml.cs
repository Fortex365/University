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

namespace Cviceni3_Ukol
{
    //Autor: Netřeba Lukáš
    //Datum: 12.10.2020

    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            int n = 0;

            try
            {
                n = int.Parse(Input.Text);
            }

            //Chybný formát
            catch (FormatException)
            {
                Input.Text = "";
                Output.Text = "Chybný formát vstupu";
            }

            //Přetečení vstupu
            catch(OverflowException)
            {
                Input.Text = "";
                Output.Text = "Přetečení vstupní hodnoty";
            }
            finally
            {


                //Provedení hlavní činnosti programu, výpis prvočísel <= zadané n
                for(int j = 2; j <= n; j++)
                {
                 if (isPrime(j))
                 {
                    Output.Text = Output.Text + j + ", ";
                 }
                }

            }
        }

        //Metoda testování prvočíselnosti
        private static Boolean isPrime(int m)
        {
            if (m <= 1)
                return false;

            for(int i = 2; i < m; i++)
            {
                if(m % i == 0)
                {
                    return false;
                }
            }
            return true;
        }

        //Metoda navíc pro resetování textboxů
        private void Reset_Click(object sender, RoutedEventArgs e)
        {
            Input.Text = "";
            Output.Text = "";
        }
    }
}
