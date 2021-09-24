using System;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Web.Script.Serialization;


namespace XML_JSON
{
    class Program
    {
        static void Main(string[] args)
        {
            secndYear(@"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\XML-JSON\studentiPredmetu.xml", @"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\XML-JSON\druhaci.json");
            covidAvg(@"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\XML-JSON\nakaza.json", @"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\XML-JSON\nakazaAverages.xml");
            subjectsFirstN(@"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\XML-JSON\predmetyKatedry.xml", @"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\XML-JSON\firstNSubjects.xml", 20);
            Console.ReadLine();
        }

        static void secndYear(string inputPath, string outputPath)
        {
            Student[] students;

            try
            {
                XmlDocument xmldoc = new XmlDocument();
                xmldoc.Load(inputPath);
                XmlNodeList secondYearStudentsNodes = xmldoc.SelectNodes("/studentiPredmetu/*[rocnik=2]");

                students = new Student[secondYearStudentsNodes.Count];
                int iter = 0;
                foreach (XmlNode node in secondYearStudentsNodes)
                {
                    students[iter++] = new Student()
                    {
                        StudyYear = short.Parse(node.SelectSingleNode("rocnik").InnerText),
                        Name = node.SelectSingleNode("jmeno").InnerText,
                        Surname = node.SelectSingleNode("prijmeni").InnerText,
                    };
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }

            string json;

            try
            {
                json = new JavaScriptSerializer().Serialize(students);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }

            try
            {
                StreamWriter tw = new StreamWriter(File.Create(outputPath));
                tw.Write(json);
                Console.WriteLine("Úspěšně zapsáno studentiPredmetu.xml -> JSON do souboru: {0}", outputPath);
                tw.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }
        }

        static void covidAvg(string inputPath, string outputPath)
        {
            Nakaza.Root json;

            try
            {
                StreamReader source = File.OpenText(inputPath);
                json = (Nakaza.Root)new JavaScriptSerializer().Deserialize(source.ReadToEnd(), typeof(Nakaza.Root));
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }

            Nakaza.DailyInf[] dailyInf = json.Data;

            if (dailyInf.Length < 7)
            {
                return;
            }

            double sevenAvg = 0;

            for (int i = 0; i < 7; i++)
            {
                sevenAvg += dailyInf[i].prirustkovy_pocet_nakazenych;
            }

            sevenAvg = Math.Round(sevenAvg / 7.0, 2);

            XmlDocument doc = new XmlDocument();
            XmlDeclaration xmlDeclaration = doc.CreateXmlDeclaration("1.0", "UTF-8", null);

            XmlElement root = doc.DocumentElement;
            doc.InsertBefore(xmlDeclaration, root);

            XmlElement node = doc.CreateElement("Covid");
            doc.AppendChild(node);

            XmlElement avg;

            for (int i = 7; i < dailyInf.Length; i++)
            {
                avg = doc.CreateElement("avg");

                avg.SetAttribute("from", dailyInf[i - 7].datum);
                avg.SetAttribute("to", dailyInf[i - 1].datum);
                avg.InnerText = sevenAvg.ToString(); 

                node.AppendChild(avg);

                sevenAvg -= Math.Round(dailyInf[i - 7].prirustkovy_pocet_nakazenych / 7.0, 2);
                sevenAvg += Math.Round(dailyInf[i].prirustkovy_pocet_nakazenych / 7.0, 2);
                sevenAvg = Math.Round(sevenAvg, 2);
            }

            avg = doc.CreateElement("avg");

            avg.SetAttribute("from", dailyInf[dailyInf.Length - 7].datum);
            avg.SetAttribute("to", dailyInf[dailyInf.Length - 1].datum);
            avg.InnerText = sevenAvg.ToString();

            node.AppendChild(avg);

            try
            {
                XmlTextWriter w = new XmlTextWriter(outputPath, Encoding.UTF8);
                doc.WriteContentTo(w);
                Console.WriteLine("Úspěšně zapsáno nakaza.json -> XML do souboru: {0}", outputPath);
                w.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }
        }

        static void subjectsFirstN(string inputPath, string outputPath, int n)
        {
            predmetyKatedry predmety;

            try
            {
                FileStream f = new FileStream(inputPath, FileMode.Open);
                XmlSerializer serializer = new XmlSerializer(typeof(predmetyKatedry));
                predmety = (predmetyKatedry)serializer.Deserialize(f);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }

            predmetyKatedryPredmetKatedry[] predmetKatedry = new predmetyKatedryPredmetKatedry[n];

            for (int i = 0; i < n; i++)
            {
                predmetKatedry[i] = predmety.predmetKatedry[i];
            }

            predmety.predmetKatedry = predmetKatedry;

            try
            {
                TextWriter tw = new StreamWriter(outputPath);
                XmlSerializer sr = new XmlSerializer(typeof(predmetyKatedry));
                sr.Serialize(tw, predmety);
                Console.WriteLine("Úspěšně serializováno {0} prvků z {1}\ndo {2}", n, inputPath, outputPath);
                tw.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return;
            }
        }
    }
}
