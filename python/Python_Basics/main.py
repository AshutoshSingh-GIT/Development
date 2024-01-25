import sys

def custom_function(x,y):
    return(x+y)
# a=custom_function(2,3)
# print(a)
# print(__name__)
# print(sys.path)

if __name__ == '__main__':
    a=custom_function(2,3)
    print(a)
    print(__name__)
    print(sys.path)

