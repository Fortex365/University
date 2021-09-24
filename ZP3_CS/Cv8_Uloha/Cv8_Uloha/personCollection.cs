using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace Cv8_Uloha
{
    class personCollection
    {
        private ArrayList collectionList;

        public personCollection()
        {
            this.collectionList = new ArrayList();
        }        

        public void Add(Person p)
        {
            collectionList.Add(p);
        }

        public int this[string Wholename]
        {
            get
            {
                foreach(Person i in collectionList)
                {
                    if((i.Surname + " " + i.Lastname) == Wholename)
                    {
                        return collectionList.IndexOf(i);
                    }
                }
                return -1;
            }
        }

        public Person this[int index]
        {
            get
            {
                return (Person)collectionList[index];
            }
        }
    }
}
