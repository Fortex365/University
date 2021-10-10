import threading
import time

from random import randint  

#-----------------------------------------
#CTRL+K+C = COMMENT, CTRL+K+U = UNCOMMENT

#Cvičný úkol 3:
#def func(i):
#    global C
#    global D
#    count = 0

#    number = C[i] #p1
#    for j in range(len(C)): #p2
#        if C[j] < number:
#            count += 1
#    D[count] = number #p3

#C = [0,1,2,3,4,5,6,7,8,9]
#D = [0,0,0,0,0,0,0,0,0,0]

#for i in range(10):
#    t = threading.Thread(target=func, args=(i,))
#    t.start()
#print(D)



#------------------------
#Paralelní násobení matic
#------------------------
def matrix_multiplication(i,j):
    global matrix_a
    global matrix_b
    global result_matrix
    result = 0
    row = matrix_a[i] #[1,2,3] prvni iterace
    column = [] #[1,3,5] prvni iterace
    for k in matrix_b:
        column.append(k[j])
    for f,b in zip(row,column):
        result += f*b
    #Zapisovani do vysledne matice
    result_matrix[i][j] = result
    

def empty_matrix(rows,columns):
    global result_matrix
    for i in range (rows):
        help = []
        for j in range(columns):
            help.append(0)
        result_matrix.append(help)
 
#-----------------------------------------------------------------------
#Vstupni matice, musi byt nasobitelne, v programu neni kontrola vstupu
#-----------------------------------------------------------------------

matrix_a = [[1,2,3],[4,5,6]]
matrix_b = [[1,2], [3,4], [5,6]]

#Zjisteni kolik radku a sloupcu bude mit vysledna matice (+pouziti pro multithreading)
rows = len(matrix_a) #počet řádků, jsou dva, jeden = [1,2,3] a druhý = [4,5,6]
columns = len(matrix_b[0]) #počet sloupců, jsou tři, jeden bude [1,3,5] a druhý [2,4,6]

#Vytvořeni vysledne matice
result_matrix = []
#Naplneni vysledne matice prazdnymi hodnotami
empty_matrix(rows,columns)
#Kontrola (nevím, jak napsat #if DEBUG {} end;)
print("Kontrola vytvoreni prazdne matice pro vysledek:",result_matrix)

for i in range(rows): #pro každý řádek matice
    for j in range(columns): #pro sloupec
        t = threading.Thread(target=matrix_multiplication, args=(i,j,)) #vytvoříme zvlášť vlákno
        t.start()

#Po výpočtu
print("Nasobeni matic ve tvaru A*B:\nKde matice A je:",matrix_a)
print("Kde matice B je:",matrix_b)
print("Vysledna matice:",result_matrix)