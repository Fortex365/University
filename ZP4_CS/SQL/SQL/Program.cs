using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace System.Data.SqlClient
{
    class Program
    {
        static string connectStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\Luky\Downloads\db.mdf;Integrated Security=True;Connect Timeout=30";

        static void Main(string[] args)
        {
            PrintFivetoFifteenUniqueNamesSortedAplhanumericallyByAscendent();
            InsertTwoNewStudents();
            DeleteINFPeopleInTable();
            ChangeStudentUserNameWhichHasPersonalNumber("krupmi01","R19548");
            PrintGradesFromSurvivedStudents();

            Console.Read();
        }

        static void PrintFivetoFifteenUniqueNamesSortedAplhanumericallyByAscendent()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectStr))
                {
                    conn.Open();
                    SqlCommand command = new SqlCommand("SELECT DISTINCT Jmeno, Prijmeni FROM students ORDER BY Prijmeni, Jmeno ASC OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;", conn);

                    using (SqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Console.WriteLine($"{dr[0]}, {dr[1]}");
                        }
                    }
                }
                Console.WriteLine();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        static void InsertTwoNewStudents()
        {
            InsertStudent("R19123", "Eliška", "Netřebová", "netrel00", 2, "APLINF");
            InsertStudent("R19124", "Pavlína", "Janoštíková", "janpav00", 3, "APLINF"); // :)
        }

        static void InsertStudent(string Cislo, string Jmeno, string Prijmeni, string Username, int Rocnik, string Obor)
        {
            try
            {
                int affected = 0;
                using (SqlConnection conn = new SqlConnection(connectStr))
                {
                    conn.Open();
                    SqlCommand command = new SqlCommand("INSERT INTO students (OsCislo, Jmeno, Prijmeni, UserName, Rocnik, OborKomb) VALUES (@arg1,@arg2,@arg3,@arg4,@arg5,@arg6);", conn);
                    command.Parameters.Add(new SqlParameter("arg1", Cislo));
                    command.Parameters.Add(new SqlParameter("arg2", Jmeno));
                    command.Parameters.Add(new SqlParameter("arg3", Prijmeni));
                    command.Parameters.Add(new SqlParameter("arg4", Username));
                    command.Parameters.Add(new SqlParameter("arg5", Rocnik));
                    command.Parameters.Add(new SqlParameter("arg6", Obor));

                    affected = command.ExecuteNonQuery();
                }
                Console.WriteLine($"Query changes (added): {affected}\n");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        static void DeleteINFPeopleInTable()
        {
            try
            {
                int affected = 0;
                using (SqlConnection conn = new SqlConnection(connectStr))
                {
                    conn.Open();
                    SqlCommand command = new SqlCommand("DELETE FROM students WHERE oborKomb = @arg1", conn);
                    command.Parameters.Add(new SqlParameter("arg1", "INF"));

                    affected = command.ExecuteNonQuery();
                }
                Console.WriteLine($"Query changes (deletes): {affected}\n");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

        }

        static void ChangeStudentUserNameWhichHasPersonalNumber(string UserName, string PersonalNumber)
        {
            try
            {
                int affected = 0;
                using (SqlConnection conn = new SqlConnection(connectStr))
                {
                    conn.Open();
                    SqlCommand command = new SqlCommand("UPDATE students SET UserName=@arg1 WHERE OsCislo=@arg2", conn);
                    command.Parameters.Add(new SqlParameter("arg1", "UserName"));
                    command.Parameters.Add(new SqlParameter("arg2", "PersonalNumber"));


                    affected = command.ExecuteNonQuery();
                }
                Console.WriteLine($"Query changes (update): {affected}\n");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

        }

        static void PrintGradesFromSurvivedStudents()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectStr))
                {
                    conn.Open();
                    SqlCommand command = new SqlCommand("SELECT exams.Grade, exams.Subject, students.Jmeno, students.Prijmeni FROM students INNER JOIN exams ON students.OsCislo = exams.StudentOsCislo; ", conn);

                    using (SqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Console.WriteLine($"{dr[0]}, {dr[1]}, {dr[2]}, {dr[3]}");
                        }
                    }
                }
                Console.WriteLine();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
