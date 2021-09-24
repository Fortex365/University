"""
Zadání:

Pomocí zasílání zpráv naprogramujte paralelní násobení matic,
kde A a B jsou čtvercové matice reprezentované seznamy.
Počet procesorů použitých pro výpočet bude roven velikosti matice A,
kde proces i vypočítá i-tý řádek matice C.

Více viz. http://vyjidacek.cz/papr4/lecture11.html
"""

"""
Autor: Lukáš Netřeba
Date: 2.5.2021
"""

from mpi4py import MPI

#Funkce
def calculate_row_MC(row_A):
    global B
    new_row_C = []

    for i in range(len(row_A)):
        value = V_multiply_scalar(row_A, i_column_of(B,i))
        new_row_C.append(value)
    return new_row_C

def i_column_of(M, i):
    column = []

    for row in M:
        column.append(row[i])

    return column

def V_multiply_scalar(vector, mul_vector):
    value = 0
    for e, f in zip(vector, mul_vector):
        value += e*f
    return value


#Inicializace Message Passing Interface
comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

#Spouštět 'mpiexec -n 3 py MPI.py', kde 3 je velikost matic.
#Matrix A
MA = [[1,2,3],[4,5,6],[7,8,9]]

#Matrix B
MB = [[1,1,1],[2,2,2],[3,3,3]]


#Scatterování násobence
if rank == 0:
    data = MA
else:
    data = None

local_row = comm.scatter(data, root=0)


#Broadcast násobitele
if rank == 0:
    data2 = MB
else:
    data2 = None

B = comm.bcast(data2,root=0)

#Výpočet
new_row_C = calculate_row_MC(local_row)

#Matrix C
MC = comm.gather(new_row_C, root=0)

#Output
if rank == 0:
    print(MC)
else:
    var = MC is None


