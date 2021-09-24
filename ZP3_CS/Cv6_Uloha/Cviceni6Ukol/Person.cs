using System;
using System.Collections.Generic;
using System.Text;

namespace Cviceni6Ukol
{
    //enum Gender { Male, Female }

    class Person
    {
        protected string name;
        protected string personal_id;
        protected string gender;

        public Person(string n, string id, string gndr)
        {
            this.name = n;
            this.personal_id = id;
            this.gender = gndr;
        }

        //zmen_jmeno()
        public void changeName(string n)
        {
            this.name = n;
        }

        //zmen_rc()
        public void changeID(string id)
        {
            this.personal_id = id;
        }

        public void changeGender(string g)
        {
            this.gender = g;
        }

        //pohlavi()
        public string Gender()
        {
            return this.gender;
        }

        //vypis()
       virtual public void personPrint()
        {
            Console.Write("Name: {0} | ID: {1} | Gender: {2} | ", this.name, this.personal_id, this.gender);
        }
    }
}
