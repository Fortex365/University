using System;
using System.Collections.Generic;
using System.Text;

namespace Cviceni6Ukol
{
    class Student : Student_School
    {
        private string courseOfStudy;

        public Student(string n, string id, string gndr, string nameOfSchool, string courseName) :base(n, id, gndr, nameOfSchool)
        {
            this.courseOfStudy = courseName;
        }

        public void setCourse(string courseName)
        {
            this.courseOfStudy = courseName;
        }

        //vypis()
        public override void personPrint()
        {
            base.personPrint(); ////volá metodu stejného názvu v předkovi
            Console.Write("Course of Study: {0}\n", this.courseOfStudy);
        }
    }
}
