## Source :: Four pillars of python OOP'S (udemy)

class library:
    def __init__(self, listOfBooks):
        self.listBook=listOfBooks

    def displayAvailableBook(self):
        print("List of book available in library are : ")
        for seq, book in enumerate(self.listBook):
            print(f"{seq} : {book}")
            
    def lendBook(self, reqBook): 
        if reqBook in self.listBook:
            self.listBook.remove(reqBook)
            print( "Kindly return the book post 7 days")
        else:
            print("Sorry, book is not available in library at this moment")

    def addBook(self, retBook):
        self.listBook.append(retBook)
        print("Thakyou for returning the book, have a good day.")

class customer:
    def requestBook(self):
        self.reqBook=input(f"Enter the name of the book you want to request: ") 
        return self.reqBook
    
    def returnBook(self):
        self.retBook=input(f"Enter the name of the book you want to return : ") 
        return self.retBook

Lib1 = library(
    [
        "Wings Of Fire",
        "For One More Time",
        "Rich Dad Poor Dad",
        "Animal Farm",
        "Riverdale Adventure",
        "Bharat Ek Khoj",
        "Nizam of Hyderabad",
        "Humans of Bombay",
        "Ship of Theseus",
        "The Intelligent investor",
        "JRE Experience",
    ])
cust1 = customer()

while True:
    print("Enter 1 to browse available books catalog.")
    print("Enter 2 to borrow an available book.")
    print("Enter 3 to return a borrowed book.")
    print("Enter 4 to exit the library program.")
    userinput=int(input(f"please select an option: "))
    if userinput == 1:
        Lib1.displayAvailableBook()
    elif userinput == 2:
        Lib1.lendBook(cust1.requestBook())
        Lib1.displayAvailableBook()
    elif userinput == 3:
        Lib1.addBook(cust1.returnBook())
        Lib1.displayAvailableBook()
    else:
        quit()