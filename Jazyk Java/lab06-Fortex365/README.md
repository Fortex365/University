#KMI/JJ1 Fifth homework 2021/2022

1. Navrhněte vlastní implementaci generického zásobníku Stack\<T> s omezenou kapacitou a následující funkcionalitou
+ Stack(int capacity) - konstruktor s parametrem kapacita zásobníku
+ int getCapacity() - vrátí celkovou kapacitu zásobníku
+ int length() - vrátí počet prvků v zásobníku
+ T peek() - klasický peek, který ale vyvolá EmptyStackException (viz úkol 2), pokud je zásobník prázdný.
+ void push(T element) - klasický push, který ale vyvolá FullStackException (viz úkol 2), pokud je zásobník plný
+ T pop() - klasický pop, který ale vyvolá EmptyStackException (viz úkol 2), pokud je zásobník prázdný
+ boolean isFull() - je zásobník plný?
+ boolean isEmpty() - je zásobník prázdný?
+ Optional\<T> safePop() - bezpečný pop, který vrátí Optional hodnotu
+ boolean safePush(T element) - bezpečný push, který indukuje úspěch operace pomocí návratové hodnoty true
+ Optional\<T> safePeek() - bezpečný peek, který vrátí Optional hodnotu

2. Implementujte výjimky EmptyStackException a FullStackException pro předchozí příklad.

3. Implementujte výčtový typ Action s úkoly pro robota:
- Každá operace má svůj kód a svou cenu 
- krok vpřed (STEP kód 100, cena 1000)
- krok zpět (BACK kód 200, cena 1000)
- otočit vlevo (LEFT kód 10, cena 10)
- otočit vpravo (RIGHT kód 20, cena 10)


4. Implementujte roboty používajícího zásobník z prvního úkolu pro ukládání svých programů.
  + ExceptionalRobot - používajícího operace peek, push a pop, který na výjimky zásobníku reaguje neprovedením žádné akce a vyvoláním vlastní výjimky volajícímu
    
    - ExceptionalRobot(String name, int memorySize) - konstruktor robota, name - jméno robota, memorySize - kolik instrukcí může mít v paměti
    - void readActions(Action[] actions) - vymaže zásobník a načte akce jednu po druhé do svého zásobníku (pozor na pořadí), přetečení zásobníku skončí výjimkou TooManyActions (viz úkol 5) a vyprázdněním zásobníku
    - Action move() - provede akci z vrcholu zásobníku (vrátí ji a odstraní ze zásobníku), podtečení zásobníku skončí výjimkou NoActionAvailable (viz úkol 5)
    - Action nextStep() - vrátí další plánovanou akci robota, podtečení zásobníku skončí výjimkou NoActionAvailable (viz úkol 5)
    - String toString() - String tvaru "Name: " + jméno robota + ", Action: " + vrchol zásobníku programu ve formátu "kód:cena" (je-li prázdný, tak slovo NONE)
    - boolean hasProgram() - vrátí true pokud má nějaké akce v zásobníku, jinak false
  
  + SafeRobot - používajícího operace safePeek, safePush a safePop, který úspěch/neúspěch akce reflektuje v návratovém typu
    
    - SafeRobot(String name, int memorySize) - konstruktor robota, name - jméno robota, memorySize - kolik instrukcí může mít v paměti
    - boolean readActions(Action[] actions) - vymaže zásobník a načte akce jednu po druhé do svého zásobníku (pozor na pořadí), kontroluje práci se zásobníkem pomocí safe* operací. pokud nenačte všechny operace, tak vrátí false a vyprázdní zásobník
    - Optional\<Action> move() - provede akci z vrcholu zásobníku (vrátí ji a odtsraní ze zásobníku), kontroluje práci se zásobníkem pomocí safe* operací.
    - Optional\<Action> nextStep - vrátí další plánovanou akci robota, pokud taková existuje
    - String toString() - String tvaru "Name: " + jméno robota + ", Action: " + vrchol zásobníku programu ve formátu "kód:cena" (je-li prázdný, tak slovo NONE)
    - boolean hasProgram() - vrátí true pokud má nějaké akce v zásobníku, jinak false

5. Implementujte výjimky NoActionAvailableException a TooManyActionsException pro robota ExceptionalRobot z předchozího úkolu.
