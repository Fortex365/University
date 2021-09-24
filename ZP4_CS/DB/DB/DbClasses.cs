using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;

namespace DB
{
    public class Student
    {
        public int Id { get; set; }
        public string osCislo { get; set; }
        public string jmeno { get; set; }
        public string prijmeni { get; set; }
        public string stav { get; set; }
        public string userName { get; set; }
        public string strpIdno { get; set; }
        public string nazevSp { get; set; }
        public string fakultaSp { get; set; }
        public string kodSp { get; set; }
        public string formaSp { get; set; }
        public string typSp { get; set; }
        public string typSpKey { get; set; }
        public string mistoVyuky { get; set; }
        public string rocnik { get; set; }
        public string financovani { get; set; }
        public string oborKomb { get; set; }
        public string oborIdnos { get; set; }
        public string email { get; set; }
        public string cisloKarty { get; set; }
        public string pohlavi { get; set; }
        public string evidovanBankovniUcet { get; set; }
        public string statutPredmetu { get; set; }

        public int ZnamkyPredmetuId { get; set; }
        public virtual ZnamkyPredmetu predmetZnamka { get; set; }
    }
    public class ZnamkyPredmetu
    {
        public int Id { get; set; }
        public string znamka { get; set; }
        public string nazevPredmetu { get; set; }
    }
    public class StudentContext : DbContext
    {
        public StudentContext() : base("StudentsConnection")
        {

        }
        public DbSet<Student> Students { get; set; }
        public DbSet<ZnamkyPredmetu> Znamky { get; set; }
    }
}
