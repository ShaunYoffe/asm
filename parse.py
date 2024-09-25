def tokenize(expr):
    out = []
    for i in expr:
        if i in ['+', '-', '*', '/', '^', '(', ')']:
            s = expr.split(i, 1) # s = [left, right]
            if s[0] != '':
                out.append('x' if s[0] == 'x' else float(s[0])) # out <- left
            out.append(i) # out <- op
            if s[1] != '':
                out.extend(tokenize(s[1])) # out <- right
            return out
    return ['x' if expr == 'x' else float(expr)]

print(tokenize("-x+7*(2.22^x/4.3)"))