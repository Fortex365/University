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

namespace Cv2_Ukol
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

        private void Result_Click(object sender, RoutedEventArgs e)
        {
            int A = int.Parse(IA.Text);
            int B = int.Parse(IB.Text);
            int C = int.Parse(IC.Text);
            int Per = 0;
            Per = A + B + C;

            if (((A + B) > C) & ((B + C) > A) & ((C + A) > B))
            {
                Constructable.Content = "Is constructable";
                perimeterResult.Content = Per;

            }
            else
            {
                Constructable.Content = "Is NOT constructable";
                perimeterResult.Content = "cannot compute";
            }
        }
    }
}
