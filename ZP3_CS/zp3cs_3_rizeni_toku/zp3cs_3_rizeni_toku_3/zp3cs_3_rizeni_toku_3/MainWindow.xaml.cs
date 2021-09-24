using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;


namespace MathsOperators
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

        private void vypoctiClick(object sender, RoutedEventArgs e)
        {
            int lhs = 0, rhs = 0;

            try
            {
                lhs = int.Parse(lOperand.Text);
                rhs = int.Parse(rOperand.Text);
                if ((bool)remainder.IsChecked)
                {
                    remainderValues(lhs, rhs);
                }
                else
                {
                    throw new InvalidOperationException("Nebyl vybrán žádný operátor");
                }
            }
            catch(FormatException ex)
            {
                vysledek.Text = "";
                odpoved.Text = "Chybný formát vstupu";
            }
            catch(OverflowException ex)
            {
                vysledek.Text = "";
                odpoved.Text = "Na vstupu je příliš veliké číslo";
            }
            catch(DivideByZeroException ex)
            {
                vysledek.Text = "";
                odpoved.Text = "Došlo k dělení nulou";
            }
            //catch(exception ex)
            //{
            //    vysledek.text = "";
            //    odpoved.text = ex.message;
            //}

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

        

        private void addValues(int leftHandSide, int rightHandSide)
        {
            int outcome;
            outcome = leftHandSide + rightHandSide;
            vysledek.Text = lOperand.Text + " + " + rOperand.Text;
            vysledek.Text = outcome.ToString();
        }

        private void subtractValues(int leftHandSide, int rightHandSide)
        {
            int outcome;
            outcome = leftHandSide - rightHandSide;
            odpoved.Text = lOperand.Text + " - " + rOperand.Text;
            vysledek.Text = outcome.ToString();
        }

        private void multiplyValues(int leftHandSide, int rightHandSide)
        {
            int outcome;
            outcome = leftHandSide * rightHandSide;
            odpoved.Text = lOperand.Text + " * " + rOperand.Text;
            vysledek.Text = outcome.ToString();
        }

        private void divideValues(int leftHandSide, int rightHandSide)
        {
            int outcome;
            outcome = leftHandSide / rightHandSide;
            odpoved.Text = lOperand.Text + " / " + rOperand.Text;
            vysledek.Text = outcome.ToString();
        }

        private void remainderValues(int leftHandSide, int rightHandSide)
        {
            int outcome;
            outcome = leftHandSide % rightHandSide;
            odpoved.Text = lOperand.Text + " % " + rOperand.Text;
            vysledek.Text = outcome.ToString();
        }

        private void quitClick(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}