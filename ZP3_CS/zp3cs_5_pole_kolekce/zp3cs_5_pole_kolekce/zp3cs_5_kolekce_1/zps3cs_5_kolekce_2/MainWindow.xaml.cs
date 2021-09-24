using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Shapes;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;

namespace Karty
{
    public partial class Game : Window
    {
        public const int Hracu = 4;
        public const int PocetKaret = 8;
        
        
        

        public Game()
        {
            InitializeComponent();
        }

        private void rozdat_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Balik balik = new Balik();
                Hrac[] hraci = { new Hrac(PocetKaret), new Hrac(PocetKaret), new Hrac(PocetKaret), new Hrac(PocetKaret) };
                for (int cisloHrace = 0; cisloHrace < Hracu; cisloHrace++)
                {
                    for (int cisloKarty = 0; cisloKarty < PocetKaret; cisloKarty++)
                    {
                        HraciKarta karta = balik.VyberKartuZBaliku();
                        hraci[cisloHrace].PridejKartu(karta);
                    }
                }
                prvni.Text = hraci[0].ToString();
                druhy.Text = hraci[1].ToString();
                treti.Text = hraci[2].ToString();
                ctvrty.Text = hraci[3].ToString();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
