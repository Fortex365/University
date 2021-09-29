"""
Zápočtový úkol ZPP1

Zadání: Napsat funkci, která má jeden argument (pole písmen), inplace reverz pole.

Autor: Lukáš Netřeba
"""

def reverse_array(arr: list) -> list:
    """
    Function which seeks for words in array separated by '' or ' ' and reverses them individualy.
    Can return None if arr argument was passed as None or as an empty structure.
    """
    if not arr:
        return None

    start, end = 0, 0
    arr_length = len(arr)
    arr_index_max = arr_length - 1

    def _do_swap(arr: list, left: int, right: int) -> list:
        """
        Internal function which swaps inplace two items in array given by their index.
        """
        stored = arr[left]
        arr[left] = arr[right]
        arr[right] = stored
        return arr

    def _reverse_array(arr: list, start: int, end: int) -> list:
        """
        Internal function which swaps all items in a whole word.
        """
        while start < end:
            _do_swap(arr, start, end)
            start, end = start + 1, end - 1
        return arr

    while start < arr_index_max:
        if arr[end] == ' ' or arr[end] == '':
            _reverse_array(arr, start, end - 1)
            start = end +1
        if end == arr_index_max:
            _reverse_array(arr, start, end)
            return arr
        end += 1
    return arr

if __name__ == '__main__':
   fedcba = reverse_array(['a','b','c','d','e','f'])
   edcdba = reverse_array(['a','b','c','d','e'])
   cba_fe = reverse_array(['a','b','c',' ','e','f'])
   a = reverse_array(['a'])
   none = reverse_array(None)
   empty_arr = reverse_array([])

   print(f'{fedcba}\n{edcdba}\n{cba_fe}\n{a}\n{none}\n{empty_arr}')