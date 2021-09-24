namespace Karty
{
    using System;
    using System.Collections;
    using System.Linq;

    class Balik
    {
        public const int pocetBarev = 4;
        public const int pocetHodnot = 13;
        
        private int pocetKaretVBaliku = 0;
        private Random nahodnyVyberKaret = new Random();

        private ArrayList balikKaret;


        //Vytvoří do dynamického pole balikKaret všechny možnosty hodnoty a barvy karet. Vytvoří se tak kompletní balíček.
        public Balik()
        {
            this.balikKaret = new ArrayList();
            for(Barvy barva = Barvy.Kříže; barva <= Barvy.Piky; barva++)
            {
                for(Hodnoty hodnota = Hodnoty.Dvojka; hodnota <= Hodnoty.Eso; hodnota++)
                {
                    this.balikKaret.Add(new HraciKarta(barva, hodnota));
                }
            }    
        }

        //Vybere náhodnou kartu z balíčku, odstraní ji, aby nebyla už znova vytažena a vypíše jí, simuluje vytáhnutí karty z balíku
        public HraciKarta VyberKartuZBaliku()
        {
            int cisloKarty = (int)nahodnyVyberKaret.Next(pocetKaretVBaliku);
            HraciKarta karta = (HraciKarta)balikKaret[cisloKarty];
            balikKaret.Remove(karta);
            return karta;
        }
    }
}