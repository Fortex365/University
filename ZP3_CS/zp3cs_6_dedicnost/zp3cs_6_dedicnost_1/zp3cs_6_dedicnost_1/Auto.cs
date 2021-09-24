using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace zp3cs_6_dedicnost_1
{
    class Auto : Vozidlo
    {
        private static int pocet = 0;

        public Auto()
        {
            this.cislo = ++pocet;
            this.cinnost = "jezdí";
            this.pocet_kol = 4;
        }

        public override string ToString()
        {
            return "Auto číslo: " + cislo.ToString() + ", činnost: " + cinnost + ", počet kol: " + pocet_kol.ToString() + ".";
        }
    }
}
