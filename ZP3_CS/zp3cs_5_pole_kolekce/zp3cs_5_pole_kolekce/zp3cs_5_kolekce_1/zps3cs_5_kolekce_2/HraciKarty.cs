using System.Windows;

namespace Karty
{
    enum Barvy { Kříže, Káry, Srdce, Piky }
    enum Hodnoty { Dvojka, Trojka, Čtyřka, Pětka, Šestka, Sedmička, Osmička, Devítka, Desítka, Kluk, Královna, Král, Eso }
    class HraciKarta
    {
        private readonly Barvy barva;
        private readonly Hodnoty hodnota;

        public HraciKarta(Barvy b, Hodnoty h)
        {
            this.barva = b;
            this.hodnota = h;
        }

        public override string ToString()
        {
            return string.Format("{0} - {1}", this.hodnota, this.barva);
        }

        public Barvy BarvaKarty()
        {
            return this.barva;
        }

        public Hodnoty HodnotaKarty()
        {
            return this.hodnota;
        }
    }
}