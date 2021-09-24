using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace zp3cs_6_dedicnost_1
{
    class Letadlo : Vozidlo
    {
        private static int pocet = 0;

        public Letadlo()
        {
            this.cislo = ++pocet;
            this.cinnost = "létá";
            this.pocet_kol = 3;
        }

        public override string ToString()
        {
            return "Letadlo číslo: " + cislo.ToString() + ", činnost: " + cinnost + ", počet kol: " + pocet_kol.ToString() + ".";
        }
    }
}
