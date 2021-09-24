using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LINQ
{
    class Program
    {
        static void Main(string[] args)
        {
            //Oldschool way
            var students = ReadonlyDB.Students;
            MergeSort.Sort(students);
            UniqueStudents(students, 5, 15);
            Console.WriteLine();

            //LINQ way
            var students_linq = ReadonlyDB.Students;
            UniqueStudentsLINQ(students_linq, 5, 15);
            Console.WriteLine();

            StudentsFifthYearLINQ(students_linq);
            Console.WriteLine();

            StudentsInfsLINQ(students_linq);
            Console.WriteLine();

            StudentsExistsLukasLINQ(students_linq);
            Console.Read();
        }

        static void UniqueStudents(Student[] students, int from, int to)
        {
            List<Student> Uniques = MakeUnique(students);
            for(int i = from-1; i < to; i++)
            {
                Console.WriteLine(Uniques[i].ToString());
            }
        }

        static bool IsUnique(IEnumerable<Student> students, Student student)
        {
            foreach(var s in students)
            {
                if((s.Jmeno == student.Jmeno) && (s.Prijmeni == student.Prijmeni))
                {
                    return false;
                }
            }
            return true;
        }

        static List<Student> MakeUnique(Student[] students)
        {
            List<Student> UniqueStudent = new List<Student>();
            foreach(var i in students)
            {
                if (IsUnique(UniqueStudent, i))
                {
                    UniqueStudent.Add(i);
                }
            }
            return UniqueStudent;
        }

        //LINQ

        static void UniqueStudentsLINQ(Student[] students, int from, int to)
        {
            var s = students.GroupBy(p => new { p.Jmeno, p.Prijmeni }).Select(g => g.First())
                .OrderBy(p => p.Prijmeni).ThenBy(p => p.Jmeno).Skip(from - 1).Take(to - from + 1);

            foreach(var i in s)
            {
                Console.WriteLine(i.ToString());
            }

        }

        static void StudentsFifthYearLINQ(Student[] students)
        {
            try
            {
                Console.WriteLine(students.First(p => p.Rocnik > 4).ToString());
            }
            catch
            {
                Console.WriteLine("Nebyl nazelen žádný ročník 5 a vyšší.");
            }
        }

        static void StudentsInfsLINQ(Student[] students)
        {
            var c = students.Count(p => p.OborKomb == "INF");
            Console.WriteLine("Studentů s oborem INF je {0}", c);
        }

        static void StudentsExistsLukasLINQ(Student[] students)
        {
            var s = students.Any(p => p.Jmeno == "Lukáš");
            Console.WriteLine("Existuje někdo se jménem Lukáš? {0}", s);
        }
    }
}
