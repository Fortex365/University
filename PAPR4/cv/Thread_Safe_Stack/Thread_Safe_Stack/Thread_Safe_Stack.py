import threading

class Stack:
    stack = []
    
    def __init__(self):
        self.stack = []
        self.stack_lock = threading.Semaphore(1)

    def _print_stack(self):
        print(self.stack)

    def pop(self):
        if(self.is_empty() == True): #Když je stack prázdný vrací none
            return None
        else: #Jinak vrací last in
            self.stack_lock.acquire() #Zamknutí stacku
            return_value =  self.stack.pop() 
            self.stack_lock.release() #Odemknutí stacku
            return return_value


    def push(self, value):
        self.stack_lock.acquire() #Zamknutí prvků stacku
        self.stack.append(value) #Pushuje stylem lifo
        self.stack_lock.release() #Odemknutí prvků stacku
            
    def is_empty(self):
        self.stack_lock.acquire() #Zamknutí prvků stacku
        if(len(self.stack) == 0): #Stack je prázdný, když seznam (který ho reprezentuje) je délky 0
            self.stack_lock.release() #Odemknutí prvků stacku
            return True
        else: #Jinak stack není prázdný
            self.stack_lock.release() #Odemknutí prvků stacku
            return False

#------------------
#Malá dokumentace
#------------------

#Vytvoření stacku
my_stack = Stack()

#Naplnění stacku
my_stack.push(3)
my_stack.push(2)
my_stack.push(1)

#Odebrání prvku ze stacku
print("Popped item: "+ str(my_stack.pop()))

#Testovací funkce obsahu
my_stack._print_stack()

#Vlastnost (metoda) is_empty
if(my_stack.is_empty()):
    print("Stack is empty.")
else:
    print("Stack isn't empty.")

#Odebrání dalších dvou prvků
print("Popped item: "+ str(my_stack.pop()))
print("Popped item: "+ str(my_stack.pop()))

#Odebrání prvku při prázdném stacku
print("Popped item: "+ str(my_stack.pop()))

