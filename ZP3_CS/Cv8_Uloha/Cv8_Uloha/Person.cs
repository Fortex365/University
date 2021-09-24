using System;
using System.Collections.Generic;
using System.Text;

namespace Cv8_Uloha
{
    class Person
    {
        public string Surname { get; set; }
        public string Lastname { get; set; }
        public string Address { get; set; }
        public int Age { get; set; }

        public Person(string sn, string ln, string addr, int age)
        {
            this.Surname = sn;
            this.Lastname = ln;
            this.Address = addr;
            this.Age = age;
        }

        public override string ToString()
        {
            return string.Format("Surname: {0}, Lastname: {1}, Address: {2}, Age: {3}", this.Surname, this.Lastname, this.Address, this.Age);
        }
    }
}
