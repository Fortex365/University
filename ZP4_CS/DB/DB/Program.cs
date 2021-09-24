using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace DB
{
    class Program
    {
        static void Main(string[] args)
        {
            XMLToDb(@"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\DB\studentiPredmetu.xml"); //Path xml souboru
            UniqueStudents(5, 15);
            Console.Read();
        }

        static void XMLToDb(string inputPath) 
        {
            Student[] students;

            try //Překopírování studentů z xml do naší třídy pro Db
            {
                XmlDocument xmldoc = new XmlDocument();
                xmldoc.Load(inputPath);
                XmlNodeList allStudentsInXML = xmldoc.SelectNodes("/studentiPredmetu/*");

                students = new Student[allStudentsInXML.Count];
                int iter = 0;
                foreach (XmlNode node in allStudentsInXML)
                {
                    students[iter++] = new Student()
                    {
                        osCislo = node.SelectSingleNode("osCislo") != null ?
                            node.SelectSingleNode("osCislo").InnerText : "",

                        jmeno = node.SelectSingleNode("jmeno") != null ?
                            node.SelectSingleNode("jmeno").InnerText : "",

                        prijmeni = node.SelectSingleNode("prijmeni") != null ?
                            node.SelectSingleNode("prijmeni").InnerText : "",

                        stav = node.SelectSingleNode("stav") != null ?
                            node.SelectSingleNode("stav").InnerText : "",

                        userName = node.SelectSingleNode("userName") != null ?
                            node.SelectSingleNode("userName").InnerText : "",

                        strpIdno = node.SelectSingleNode("stprIdno") != null ?
                            node.SelectSingleNode("stprIdno").InnerText : "",

                        nazevSp = node.SelectSingleNode("nazevSp") != null ?
                            node.SelectSingleNode("nazevSp").InnerText : "",

                        fakultaSp = node.SelectSingleNode("fakultaSp") != null ?
                            node.SelectSingleNode("fakultaSp").InnerText : "",

                        kodSp = node.SelectSingleNode("kodSp") != null ?
                            node.SelectSingleNode("kodSp").InnerText : "",

                        formaSp = node.SelectSingleNode("formaSp") != null ?
                            node.SelectSingleNode("formaSp").InnerText : "",

                        typSp = node.SelectSingleNode("typSp") != null ?
                            node.SelectSingleNode("typSp").InnerText : "",

                        typSpKey = node.SelectSingleNode("typSpKey") != null ?
                            node.SelectSingleNode("typSpKey").InnerText : "",

                        mistoVyuky = node.SelectSingleNode("mistoVyuky") != null ?
                            node.SelectSingleNode("mistoVyuky").InnerText : "",

                        rocnik = node.SelectSingleNode("rocnik") != null ?
                            node.SelectSingleNode("rocnik").InnerText : "",

                        financovani = node.SelectSingleNode("financovani") != null ?
                            node.SelectSingleNode("financovani").InnerText : "",

                        oborKomb = node.SelectSingleNode("oborKomb") != null ?
                            node.SelectSingleNode("oborKomb").InnerText : "",

                        oborIdnos = node.SelectSingleNode("oborIdnos") != null ?
                           node.SelectSingleNode("oborIdnos").InnerText : "",

                        email = node.SelectSingleNode("email") != null ?
                            node.SelectSingleNode("email").InnerText : "",

                        //Petr Meixner nemá kartu!
                        cisloKarty = node.SelectSingleNode("cisloKarty") != null ?
                            node.SelectSingleNode("cisloKarty").InnerText : "",

                        pohlavi = node.SelectSingleNode("pohlavi") != null ?
                            node.SelectSingleNode("pohlavi").InnerText : "",

                        evidovanBankovniUcet = node.SelectSingleNode("evidovanBankovniUcet") != null ?
                            node.SelectSingleNode("evidovanBankovniUcet").InnerText : "",

                        statutPredmetu = node.SelectSingleNode("statutPredmetu") != null ?
                            node.SelectSingleNode("statutPredmetu").InnerText : "",

                    };
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }

            //Finally vložení do Db
            try
            {
                foreach(Student s in students) //Pro každého studenta v poli
                {
                    using(StudentContext ctx = new StudentContext()) //Pomocí kontextu databáze
                    {
                        ZnamkyPredmetu pushZnamkaPredmetu = new ZnamkyPredmetu
                        {
                            nazevPredmetu = "ZP4CS",
                            znamka = GenRandomGrade(),
                        };
                        Student pushStudent = s;
                        s.predmetZnamka = pushZnamkaPredmetu;
                        ctx.Students.Add(pushStudent); //Vložíme ho tam
                        ctx.SaveChanges(); //Uložíme změny v Db
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

        }
        static string GenRandomGrade()
        {
            var r = new Random();
            int num = r.Next(1, 4);
            return num.ToString();
        }

        static void UniqueStudents(int from, int to)
        {
            try
            {
                using (StudentContext ctx = new StudentContext())
                {
                    foreach(Student s in ctx.Students.GroupBy(p => new { p.jmeno, p.prijmeni }).Select(g => g.FirstOrDefault())
                .OrderBy(p => p.prijmeni).ThenBy(p => p.jmeno).Skip(from - 1).Take(to - from + 1))
                    {
                        Console.WriteLine($"{s.jmeno}, {s.prijmeni}");
                    }
                    ctx.Database.Log = Console.WriteLine;
                }
            }
            catch(Exception e)
            {
                Console.WriteLine(e);
            }
        }
    }
}
