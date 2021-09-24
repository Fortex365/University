using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Threading_MergeSort
{
    class MergeSort
    {
        // Merges two subarrays of arr[].
        // First subarray is arr[l..m]
        // Second subarray is arr[m+1..r]
        // Inplace Implementation
        static void merge(int[] arr, int start, int mid, int end)
        {
            int start2 = mid + 1;

            // If the direct merge is already sorted
            if (arr[mid] <= arr[start2])
            {
                return;
            }

            // Two pointers to maintain start
            // of both arrays to merge
            while (start <= mid && start2 <= end)
            {

                // If element 1 is in right place
                if (arr[start] <= arr[start2])
                {
                    start++;
                }
                else
                {
                    int value = arr[start2];
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

        /* l is for left index and r is right index of the 
        sub-array of arr to be sorted */
        static void mergeSort(int[] arr, int l, int r)
        {
            if (l < r)
            {

                // Same as (l + r) / 2, but avoids overflow
                // for large l and r
                int m = l + (r - l) / 2;

                // Sort first and second halves
                mergeSort(arr, l, m);
                mergeSort(arr, m + 1, r);

                merge(arr, l, m, r);
            }
        }

        /* UTILITY FUNCTIONS */
        /* Function to print an array */
        static void printArray(int[] A, int size)
        {
            int i;
            for (i = 0; i < size; i++)
                Console.Write(A[i] + " ");
            Console.WriteLine();
        }
    }
}
