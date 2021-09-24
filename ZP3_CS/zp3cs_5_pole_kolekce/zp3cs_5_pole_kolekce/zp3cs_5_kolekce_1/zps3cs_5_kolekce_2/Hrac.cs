namespace Karty
{
    using System;
    using System.Collections;

    class Hrac
    {
        public int max;
        private int pocet = 0;
        private HraciKarta[] karty;


        public override string ToString()
        {
            string s = "";
            foreach (HraciKarta karta in this.karty)
            {
                if (karta != null) s += karta.ToString() + Environment.NewLine;
            }

            return s;
        }


        public Hrac()
        {
            this.max = 8;
            karty = new HraciKarta[this.max];
        }

        public Hrac(int m)
        {
            this.max = m;
            karty = new HraciKarta[this.max];
        }

        public void PridejKartu(HraciKarta karta)
        {
            if(this.pocet >= max)
            {
                throw new ArgumentException("Příliš mnoho karet");
            }
            this.karty[this.pocet] = karta;
            this.pocet++;
        }
    }
}