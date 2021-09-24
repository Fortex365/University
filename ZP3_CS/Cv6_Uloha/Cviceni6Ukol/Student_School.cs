using System;
using System.Collections.Generic;
using System.Text;

namespace Cviceni6Ukol
{
    class Student_School : Person
    {
        protected string school;

        public Student_School(string n, string id, string gndr, string nameOfSchool) :base(n, id, gndr)
        {
            this.school = nameOfSchool;
        }

        //nastav_skolu()
        public void setSchool(string nameOfSchool)
        {
            this.school = nameOfSchool;
        }

        //vypis()
       public override void personPrint()
        {
            base.personPrint(); //volá metodu stejného názvu v předkovi
            Console.Write("School: {0} | ", this.school);
        }
    }
}
