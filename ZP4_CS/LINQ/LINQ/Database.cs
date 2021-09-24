using System;
using System.Collections.Generic;

namespace LINQ
{
    public class Student : IComparable
    {
        public string OsCislo { get; set; }
        public string Jmeno { get; set; }
        public string Prijmeni { get; set; }
        public string UserName { get; set; }
        public int Rocnik { get; set; }
        public string OborKomb { get; set; }

        public override string ToString()
        {
            return $"{OsCislo}, {Jmeno}, {Prijmeni}, {UserName}, {Rocnik}, {OborKomb}";
        }

        public int CompareTo(object obj)
        {
            var other = obj as Student;
            if(other == null)
            {
                return 1;
            }

            if(string.Compare(this.Prijmeni,other.Prijmeni) == 0)
            {
                if (string.Compare(this.Jmeno, other.Jmeno) > 0)
                {
                    return 1;
                }
                if(string.Compare(this.Jmeno,other.Jmeno) < 0)
                {
                    return -1;
                }
                if(string.Compare(this.Jmeno,other.Jmeno) == 0)
                {
                    return 0;
                }
            }
            else if(string.Compare(this.Prijmeni,other.Prijmeni) < 0)
            {
                return -1;
            }
            else if(string.Compare(this.Prijmeni,other.Prijmeni) > 0)
            {
                return 1;
            }
            return -1;
        }

    }

    public class ReadonlyDB
    {
        public static Student[] Students = new Student[]{
        new Student() {OsCislo="R19118", Jmeno="Ondřej",Prijmeni="BERČÍK",UserName="bercon00",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19705", Jmeno="Michal",Prijmeni="BEZDĚK",UserName="bezdmi01",OborKomb="APLINF"},
        new Student() {OsCislo="R19707", Jmeno="Jakub",Prijmeni="BRÁZDIL",UserName="brazja01",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19709", Jmeno="Dominik Ján",Prijmeni="BYSTRIANSKÝ",UserName="bystdo01",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R18557", Jmeno="Veronika",Prijmeni="ELŠÍKOVÁ",UserName="elsive00",OborKomb="APLINF", Rocnik=3},
        new Student() {OsCislo="R190175", Jmeno="František",Prijmeni="HASTÍK",UserName="hastfr00",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R18569", Jmeno="Václav",Prijmeni="KLVAŇA",UserName="klvava00",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19733", Jmeno="Iveta",Prijmeni="KOVAŘÍKOVÁ",UserName="kovaiv04",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19730", Jmeno="Iveta",Prijmeni="KOVAŘÍKOVÁ",UserName="kovaiv05",OborKomb="INF", Rocnik=4},
        new Student() {OsCislo="R19548", Jmeno="Michal",Prijmeni="KRUPÍK",UserName="krupmi02",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19734", Jmeno="Martin",Prijmeni="KRÚZA",UserName="kruzma00",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19736", Jmeno="David",Prijmeni="KUČERA",UserName="kuceda07",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19739", Jmeno="Rostislav",Prijmeni="LIŠKA",UserName="liskro00",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R190685", Jmeno="Petr",Prijmeni="MEIXNER",UserName="meixpe00",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19743", Jmeno="Erik Daniel",Prijmeni="MURGAŠ",UserName="murger00",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19744", Jmeno="Tomáš",Prijmeni="NÁDVORNÍK",UserName="nadvto01",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R190733", Jmeno="Lukáš",Prijmeni="NETŘEBA",UserName="netrlu00",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19747", Jmeno="Katarína",Prijmeni="OLEJKOVÁ",UserName="olejka02",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19748", Jmeno="Ondřej",Prijmeni="PAVELKA",UserName="paveon03",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19750", Jmeno="Václav",Prijmeni="PROCHÁZKA",UserName="procva01",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19129", Jmeno="Zdeněk",Prijmeni="RIEGEL",UserName="riegzd00",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19752", Jmeno="Karyna",Prijmeni="ROZNIUK",UserName="roznka02",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R190176", Jmeno="Yevhenii",Prijmeni="RUBANSKYI",UserName="rubaye00",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19753", Jmeno="Marek",Prijmeni="SCHINDLER",UserName="schima09",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19754", Jmeno="Martin",Prijmeni="SCHMIDKE",UserName="schmma04",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19759", Jmeno="Jan",Prijmeni="STŘELÁK",UserName="streja07",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R18603", Jmeno="Jan",Prijmeni="ŠÁNDOR",UserName="sandja00",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19173", Jmeno="Michal",Prijmeni="ŠIMČÍK",UserName="simcmi03",OborKomb="IVma-Zmi", Rocnik=2},
        new Student() {OsCislo="R19761", Jmeno="Martin",Prijmeni="ŠKULAVÍK",UserName="skulma01",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19763", Jmeno="Michal",Prijmeni="TOMÁŠEK",UserName="tomasemi",OborKomb="APLINF", Rocnik=2},
        new Student() {OsCislo="R19136", Jmeno="Martin",Prijmeni="VÍTEK",UserName="vitema03",OborKomb="INF", Rocnik=2},
        new Student() {OsCislo="R19769", Jmeno="Alexandr",Prijmeni="VYROUBAL",UserName="vyroal01",OborKomb="APLINF", Rocnik=2}}; 
    }
 }
