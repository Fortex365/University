using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace zp3cs_6_dedicnost_1
{
    class Vozidlo
    {
        protected int cislo;
        protected string cinnost;
        protected int pocet_kol;

        protected static int pocet = 0;

        public Vozidlo()
        {
            cislo = ++pocet;
        }

        public override string ToString()
        {
            return "Vozidlo číslo:" + cislo.ToString() + ", činnost: " + cinnost + ", počet kol: " + pocet_kol.ToString() + ".";
        }

    }
}
