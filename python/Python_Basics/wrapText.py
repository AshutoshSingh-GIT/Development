import textwrap

def wrap(string, max_width):
    # return textwrap.fill(string, max_width)
    newStr = ''
    for i in range(0, len(string), max_width):
        newStr += string[i:i+max_width] + '\n'
    return newStr
    

if __name__ == '__main__':
    string, max_width = 'ABCDEFGHIJKLIMNOQRSTUVWXYZa', 4
    result = wrap(string, max_width)
    print(result)