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

namespace Calculator
{
    //CTRL+K+C, CTRL+K+U zkratky pro komentování

    public partial class MainWindow : Window
    {
        const char plus = '+';
        const char minus = '-';
        const char divide = '/';
        const char multiply = '*';

        public MainWindow()
        {
            InitializeComponent();
        }

        //--------------------------------------
        //HLAVNÍ DĚNÍ PROGRAMU, ANEB = TLAČÍTKO

        private void key_result_Click(object sender, RoutedEventArgs e)
        {
            double result = 0;
            string toCalculate = Output.Text;
            char symbol;     //Iterativní proměnná pro string
            char op = '0';   //Žádný operátor, zjistí se později v kódu
            string number = "";     //Levý operand
            string number2 = "";    //Pravý operand
            double num;  //Levý operand po Parsování ze stringu na číslo
            double num2;     //Pravý operand -,,-

            //NEMÁ OPERÁTOR MEZI DVĚMI ČÍSLY
            if (!hasOperatorAfterIndex0(Output.Text)) //Číslo bez operátoru, nepočítá se - před prvním číslem, ex. +5 = 5; -5 = -5; 5 = 5; *5 = 0; /5 = 0
            {
                char charOfIndex0 = Output.Text[0];
                switch (charOfIndex0)
                {
                    case '+':  
                        Output.Text = Output.Text.Substring(1, Output.Text.Length - 1);
                    break;
                    case '-':
                        Output.Text = Output.Text;
                        break;
                    case '/':
                        for (int i = toCalculate.LastIndexOf('/') + 1; i < toCalculate.Length; i++)
                        {
                            symbol = toCalculate[i];
                            number2 += symbol;
                        }
                        try     // tj. vlastně případ když napíšete pouze "/" tudíž nemá pravé číslo žádné, ve stringu bude "" a to se nepřeparsuje
                        {
                           num2 = Double.Parse(number2);
                        }
                        catch
                        {
                            throw new DivideByZeroException("Dělení nulou! Chybějící pravý operand se defaultně bere jako nula, taktéž i levý.");
                        }
                        if (num2 == 0)      // pro všechny případy ve tvaru "/x" popř "/x,x", kde x je chápáno jako 0 ať už je v jakékoliv podobě (0,00 apod.)
                        {
                            throw new DivideByZeroException("Dělení nulou!");
                        }
                        Output.Text = "0";      // pro všechny případy ve tvaru "/x" kde x je libovolné číslo různé od 0
                        break;
                    case '*':
                        Output.Text = "0";
                        break;
                    default:    //Nedefinovaná část programu
                        throw new Exception("Undefined operator, trying extending calculator with new operator?");
                }
            }
            else    //MÁ OPERÁTOR MEZI DVĚMI ČÍSLY
            {
                //Zjistí PRVNÍ číslo před operátorem, a jaký je operátor oddělující ho od dalšího druhého čísla
                for (int i = 0; i < toCalculate.Length; i++) 
                {
                    symbol = toCalculate[i];
                    if(i == 0 && symbol == minus) //V případě záporného čísla, rovnou přepíšeme jeho záporné znaménko
                    {
                        number += symbol;
                        continue;
                    }
                   
                    if ((symbol == minus) || (symbol == plus) || (symbol == divide) || (symbol == multiply)) //Ukládá si operátor
                    {
                        op = symbol;
                        break;
                    }
                    else    //Přepisuje číslo
                    {
                        number += symbol;
                    }
                }

                //Přepisuje druhé číslo, tj. za operátorem
                for (int i = toCalculate.LastIndexOf(op) + 1; i < toCalculate.Length; i++) 
                {
                    symbol = toCalculate[i];
                    number2 += symbol;
                }

                //Nyní obě čísla ve stringu převede do čísel jako takových
                try
                {
                    num = Double.Parse(number);
                    num2 = Double.Parse(number2);

                }
                catch
                {
                    throw new ArgumentException("Chybný jeden z argumentů operátoru. Musí být ve tvaru a . b, kde a, b jsou čísla, a kde . je operátor");
                }

                //Můžeme provést operaci mezi těmi čísly.
                switch (op)
                {
                    case '+':
                        result = num + num2;
                        break;
                    case '-':
                        result = num - num2;
                        break;
                    case '/':
                        if(num2 == 0)
                        {
                            throw new DivideByZeroException("Dělení nulou!");
                        }
                        result = num / num2;
                        break;
                    case '*':
                        result = num * num2;
                        break;
                    default:
                        result = num; //popř. error
                        break;
                }
                //Výsledek operace se zapíše
                Output.Text = (Math.Round(result, 9)).ToString();

            }
        }

        //-------------------------------
        //TLAČÍTKA 4 OPERÁTORŮ +, -, *, /

        private void key_plus_Click(object sender, RoutedEventArgs e)
        {
            if (!hasOperatorAfterIndex0(Output.Text)) //Pokud tam není už jedna operace
            {
                Output.Text = Output.Text + "+";
            }
            else    //Vynutí výpočet než bude pokračovat, ex. 5+5+5 nedovolí, přepíše při stisku druhého + na 10+ a čeká na operand, 5+5+5=10+5
            {
                key_result_Click(sender, e);
                Output.Text = Output.Text + "+";

            }
        }
        private void key_minus_Click(object sender, RoutedEventArgs e)
        {
            if (!hasOperatorAfterIndex0(Output.Text)) 
            {
                Output.Text = Output.Text + "-";
            }
            else
            {
                key_result_Click(sender, e);
                Output.Text = Output.Text + "-";
            }
        }

        private void key_multiply_Click(object sender, RoutedEventArgs e)
        {
            if (!hasOperatorAfterIndex0(Output.Text)) 
            {
                Output.Text = Output.Text + "*";
            }
            else
            {
                key_result_Click(sender, e);
                Output.Text = Output.Text + "*";
            }
        }

        private void key_divide_Click(object sender, RoutedEventArgs e)
        {
            if (!hasOperatorAfterIndex0(Output.Text)) 
            {
                Output.Text = Output.Text + "/";
            }
            else
            {
                key_result_Click(sender, e);
                Output.Text = Output.Text + "/";
            }
        }

        //----------------------------------------
        //OVLÁDACÍ TLAČÍTKA AC, C, A PŘEPÍNÁNÍ +/-

        private void key_ac_Click(object sender, RoutedEventArgs e) //AC = CLEAR ALL BUTTON
        {
            Output.Text = ""; 
        }

        private void key_float_Click(object sender, RoutedEventArgs e) //Přidá desetinnou čárku, pokud je to možné. (Pozn. ,5 je validní = 0,5)
        {
            int len = Output.Text.Length;
            string afterOperation = Output.Text.Substring(findIndexOfOperator(Output.Text) + 1, len - findIndexOfOperator(Output.Text) - 1);
            if (len > 0)
            {
                if (((numOfFloats(Output.Text) == 0) && (Output.Text[len - 1] != ',')) || ((hasOperatorAfterIndex0(Output.Text)) && (numOfFloats(afterOperation) == 0)))
                {
                    Output.Text += ",";
                }
            }
            else    //Kalkulačka je prázdná, lze začít psát číslo ve tvaru ",x"
            {
                Output.Text += ",";
            }
        }

        private void key_ce_Click(object sender, RoutedEventArgs e) //Odebere poslední znak na displayi, CLEAR ENTITY BUTTON
        {
            string newstring = "";
            for (int i = 0; i < Output.Text.Length - 1; i++)
            {
                newstring += Output.Text[i];
            }
            Output.Text = newstring;
        }

        private void key_change_sign(object sender, RoutedEventArgs e) //Mění znaménko před prvním číslem
        {
            char what = '0';
            string newstring = "";

            try     //V kalkulačce na displayi není žádné číslo, je prázdné textové pole.
            {
                what = Output.Text[0];
            }
            catch
            {
                throw new Exception("Unable to asign sign");
            }

            if (what == minus)
            {
                for (int i = 1; i < Output.Text.Length; i++)
                {
                    newstring += Output.Text[i];
                }
                Output.Text = newstring;
            }
            else
            {
                newstring += '-';
                for (int i = 0; i < Output.Text.Length; i++)
                {
                    newstring += Output.Text[i];
                }
                Output.Text = newstring;
            }
        }

        //-------------------------------------------------
        //TLAČÍTKA ZAPISUJÍCÍ OBSAH DO DISPLAYE KALKULAČKY

        private void key_0_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "0";
        }

        private void key_1_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "1";

        }

        private void key_2_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "2";
        }

        private void key_3_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "3";
        }

        private void key_4_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "4";
        }

        private void key_5_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "5";
        }

        private void key_6_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "6";
        }

        private void key_7_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "7";
        }

        private void key_8_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "8";
        }

        private void key_9_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = Output.Text + "9";
        }

        //------
        //FUNKCE 

        private bool hasOperatorAfterIndex0(string s) //Predikátní funkce zjištující jestli se ve stringu už nachází jedna operace, výjímá index 0
        {
            for (int i = 1; i < s.Length; i++)
            {
                if ((s[i] == plus) || (s[i] == minus) || (s[i] == divide) || (s[i] == multiply))
                {
                    return true;
                }
            }
            return false;
        }

        private int numOfFloats(string s) //Vrací počet desetinných čárek ve stringu
        {
            int count = 0;
            for (int i = 0; i < s.Length; i++)
            {
                if (s[i] == ',')
                {
                    count++;
                }
            }
            return count;
        }

       private int findIndexOfOperator(string s) //Najde index na kterém se nachází jedna z operací.
        {
            for (int i = 1; i < s.Length; i++)
            {
                if ((s[i] == minus) || (s[i] == plus) || (s[i] == multiply) || (s[i] == divide))
                {
                    return i;
                }
            }
            return -1;
        }
    }
}
