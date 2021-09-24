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

namespace zp3cs_2_datove_typy_1
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

        private void calculate_Click(object sender, RoutedEventArgs e)
        {
            int lhs = int.Parse(lhsOperand.Text);
            int rhs = int.Parse(rhsOperand.Text);
            if ((bool)addition.IsChecked)
                addValues(lhs, rhs);
            else if ((bool)subtraction.IsChecked)
                subtractValues(lhs, rhs);
            else if ((bool)multiplication.IsChecked)
                multiplyValues(lhs, rhs);
            else if ((bool)division.IsChecked)
                divideValues(lhs, rhs);
            else if ((bool)remainder.IsChecked)
                remainderValues(lhs, rhs);

        }

        private void addValues(int lhs, int rhs)
        {
            int res;
            res = lhs + rhs;
            expression.Text = lhsOperand.Text + "+" + rhsOperand.Text;
            result.Text = res.ToString();
        }

        private void subtractValues(int lhs, int rhs)
        {
            int res;
            res = lhs - rhs;
            expression.Text = lhsOperand.Text + "-" + rhsOperand.Text;
            result.Text = res.ToString();
        }

        private void multiplyValues(int lhs, int rhs)
        {
            int res;
            res = lhs * rhs;
            expression.Text = lhsOperand.Text + "*" + rhsOperand.Text;
            result.Text = res.ToString();
        }

        private void divideValues(int lhs, int rhs)
        {
            int res = 0;
            if (rhs != 0)
            {
                res = lhs / rhs;

            }
            else if (rhs == 0)
            {
                Console.WriteLine("Dělení nulou!");

            }
            expression.Text = lhsOperand.Text + "/" + rhsOperand.Text;
            result.Text = res.ToString();
        }

        private void remainderValues(int lhs, int rhs)
        {
            int res = 0;
            if (rhs == 0)
            {
                Console.WriteLine("Modulo nuly neexistuje!");

            }
            res = lhs % rhs;
            expression.Text = lhsOperand.Text + "%" + rhsOperand.Text;
            result.Text = res.ToString();
        }

        private void quit_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
