using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Diagnostics;

namespace Threadings_MergeSort
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] arrTest = new int[10000];
            FillArrayRandomInts(arrTest, 100);

            TestMergeSortByDepth(arrTest, 0); 
            TestMergeSortByDepth(arrTest, 1);
            TestMergeSortByDepth(arrTest, 2);
            TestMergeSortByDepth(arrTest, 3);

            Console.Read();
        }

        private static void PrintArray(int[] p)
        {
            for (var i = 0; i < p.Length; i++)
            {
                Console.WriteLine(p[i].ToString());
            }
            Console.WriteLine();
        }

        private static void PrintArray(int[] p, int from, int to)
        {
            for (var i = from; i < to; i++)
            {
                Console.WriteLine(p[i].ToString());
            }
            Console.WriteLine();
        }

        private static void FillArrayRandomInts(int[] p, int limit)
        {
            Random r = new Random();

            for (int i = 0; i < p.Length; i++)
            {
                p[i] = r.Next(limit);
            }
        }

        public static void TestMergeSortByDepth(int[] array, int Depth)
        {
            Stopwatch sw = Stopwatch.StartNew();
            ParallelMergeSort.Sort(array, Depth, 0, array.Length - 1);
            sw.Stop();
            Console.WriteLine("Cas behu: {0}ms, hloubka {1}\n", sw.Elapsed.TotalMilliseconds, Depth);
        }
    }
}
