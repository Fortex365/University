using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace Threadings_MergeSort
{
    //HLAVNÍ ČÁST MERGESORTU PŘEVZANÁ Z https://www.geeksforgeeks.org/in-place-merge-sort/
    class ParallelMergeSort
    {
        // Inplace Implementation
        public static void Merge<T>(T[] arr, int start, int mid, int end) where T : IComparable<T>
        {
            int start2 = mid + 1;

            // If the direct merge is already sorted
            if (arr[mid].CompareTo(arr[start2]) <= 0)
            {
                return;
            }

            // Two pointers to maintain start
            // of both arrays to merge
            while (start <= mid && start2 <= end)
            {

                // If element 1 is in right place
                if (arr[start].CompareTo(arr[start2]) <= 0)
                {
                    start++;
                }
                else
                {
                    T value = arr[start2];
                    int index = start2;

                    // Shift all the elements between element 1
                    // element 2, right by 1.
                    while (index != start)
                    {
                        arr[index] = arr[index - 1];
                        index--;
                    }
                    arr[start] = value;

                    // Update all the pointers
                    start++;
                    mid++;
                    start2++;
                }
            }
        }

        public static void Sort<T>(T[] arr, int Depth, int l, int r) where T : IComparable<T>
        {
            if ((Depth >= 4) || (Depth < 0)) //DEPTH OUT OF RANGE
            {
                throw new Exception("Parallel Merge Sort depth out of range.");
            }
            if (l < r) //Multithreading podle hloubky
            {
                int m = l + (r - l) / 2;
                if ((0 < Depth) && (Depth < 4))
                {
                    Thread leftArray = new Thread(() => Sort(arr, Depth - 1, l, m));
                    leftArray.Start();
                    Thread rightArray = new Thread(() => Sort(arr, Depth - 1, m + 1, r));
                    rightArray.Start();
                    leftArray.Join();
                    rightArray.Join();
                }
                else //Sekvenční
                {
                    Sort(arr, Depth, l, m);
                    Sort(arr, Depth, m + 1, r);
                }
                Merge(arr, l, m, r);
            }
        }
    }
}
