#list comprehension in lexicographic increasing order 
if __name__ == '__main__':
    x = 1
    y = 1
    z = 1
    n = 2
    l1=[]
    # [l1.append([i,j,k]) for i in range(x+1) for j in range(y+1) for k in range(z+1) if i+j+k!=n]
    # print(l1)
    #print([[i,j,k] for i in range(x+1) for j in range(y+1) for k in range(z+1) if i+j+k!=n])
    for i in range (x+1):
        for j in range (y+1):
            for k in range (z+1):
                if (i+j+k!=n):
                   l1.append([i,j,k])                 
    print(l1)
 