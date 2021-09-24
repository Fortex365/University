using System;
using System.Collections.Generic;
using System.Text;

namespace Kolekce_Nezamestnanost_ZP3CS_Uloha5
{
    enum Months { None, Leden, Únor, Březen, Duben, Květen, Červen, Červenec, Srpen, Září, Říjen, Listopad, Prosinec}
    class Item
    {
        private double percentage;
        private Months month;

        //Selektor čtení ze slotu procenta
        public double getPercentage()
        {
            return this.percentage;
        }

        //Selektor čtení ze slotu měsíc
        public Months getMonth()
        {
            return this.month;
        }

        //Konstruktor, pro přidání
        public Item(double p, Months m)
        {
            this.percentage = p;
            this.month = m;
        }

        public override string ToString()
        {
            return string.Format("{0} s nezaměstnaností {1} %", this.month, this.percentage);
        }
    }
}
