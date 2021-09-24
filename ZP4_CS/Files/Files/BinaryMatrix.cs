using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Files
{
    public class BinaryMatrix
    {
        private string matrix;

        public BinaryMatrix(string path) //Konstruktor, který jen vytvoří writer
        {
            try
            {
                using (BinaryWriter sw = new BinaryWriter(File.Open(path, FileMode.Create)))
                {
                    //Prázdný
                }
            }
            catch(Exception e)
            {
                Console.WriteLine("{0}", e.Message);
            }
        }

        public void WriteMatrix(string s, string path)
        {
            try
            {
                using (BinaryWriter sw = new BinaryWriter(File.Open(path, FileMode.Create)))
                {
                    sw.Write(s);
                    matrix = s;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("{0}", e.Message);
            }

        } //Zápis do souboru a do proměnné instance

        public void ReadMatrix(string path)
        {
            try
            {
                using (BinaryReader sr = new BinaryReader(File.Open(path, FileMode.Open)))
                {
                    matrix = sr.ReadString();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("{0}", e.Message);
            }

        } //Přečtení ze souboru do proměnné instancce

        public string GetMatrix()
        {
            return matrix;
        } //Získání hodnoty instance

        public void Set(char oldNumber, int nthOccur, char newvalue)
        {
            int p;
            p = findNthOccur(matrix, oldNumber, nthOccur);
            matrix = ReplaceString.ReplaceAt(matrix, p, newvalue);

        }


        //Převzato z https://www.geeksforgeeks.org/find-the-nth-occurrence-of-a-character-in-the-given-string/
        static int findNthOccur(string str, char ch, int N)
        {
            int occur = 0;

            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == ch)
                {
                    occur += 1;
                }
                if (occur == N)
                    return i;
            }
            return -1;
        }
    }
}
