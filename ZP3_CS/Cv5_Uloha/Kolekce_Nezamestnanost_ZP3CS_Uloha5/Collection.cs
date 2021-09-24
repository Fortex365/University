using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace Kolekce_Nezamestnanost_ZP3CS_Uloha5
{
    class Collection
    {
        private ArrayList CollectionList;
        private int ItemsInCollection = 0;

        //Vytvoří kolekci, dynamický pole ArrayList
        public Collection()
        {
            this.CollectionList = new ArrayList();
        }

        //Metoda, která se zadaným item ho přidá do kolekce, bez návratové hodnoty
        public void Add(Item item)
        {
            this.CollectionList.Add(item);
            ItemsInCollection++;
        }

        //Metoda, která vrací průměr dané kolekce
        public double Avarage()
        {
            double sum = 0;
            double avg = 0;
            foreach(Item item in this.CollectionList)
            {
                sum = sum + item.getPercentage();
            }
            avg = sum / ItemsInCollection;
            return avg;
        }

        //Vrátí item, který má minimum procenta, prvek item obsahuje dvě informace (procento, a jaký měsíc)
        public Item findMin()
        {
            Item min = (Item)this.CollectionList[0];
            foreach(Item item in this.CollectionList)
            {
                if(item.getPercentage() < min.getPercentage())
                {
                    min = item;
                }
            }
            return min;
        }

        //Vrátí item, který má max procento, v item je zároveň uložen s tím spjatý měsíc
        public Item findMax()
        {
            Item max = (Item)this.CollectionList[0];
            foreach(Item item in this.CollectionList)
            {
                if(item.getPercentage() > max.getPercentage())
                {
                    max = item;
                }
            }
            return max;
        }
    }
}
