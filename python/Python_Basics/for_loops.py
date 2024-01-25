#Iterating over a string using for loop
a="ABCDEFGHIJKLIMNOQRSTUVWXYZ"
max_width=4
for i in range(0, len(a), max_width):
    b=a[i:i+max_width] + '\n'
    print(b)