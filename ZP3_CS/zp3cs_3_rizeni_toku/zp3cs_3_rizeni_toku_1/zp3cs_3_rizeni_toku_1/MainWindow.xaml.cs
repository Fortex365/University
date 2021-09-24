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

namespace zp3cs_3_rizeni_toku_1
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

        private void btnPorovnat_Click(object sender, RoutedEventArgs e)
        {
            int rozdil = porovnejData(datumPrvni.SelectedDate.Value, datumDruhe.SelectedDate.Value);
            Vypis(rozdil);
        }
        private int porovnejData(DateTime levy, DateTime pravy)
        {
            if (levy.Year < pravy.Year) return -1;
            else if (levy.Year > pravy.Year) return 1;
            else if (levy.Month < pravy.Month) return -1;
            else if (levy.Month > pravy.Month) return 1;
            else if (levy.Day < pravy.Day) return -1;
            else if (levy.Day > pravy.Day) return 1;
            else return 0;
        }
        private void Vypis(int rozdil)
        {
            if (rozdil == 0) lblVysledek.Content = "Obě data jsou stejná";
            if (rozdil == 1) lblVysledek.Content = "První je větší než druhé";
            if (rozdil == -1) lblVysledek.Content = "Druhý je větší než první";
        }
       
    }
}
