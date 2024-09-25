for i in range(256):
    c=0
    while i!=0:
        c+=1
        i&=i-1
    print(str(c)+", ",end='')

