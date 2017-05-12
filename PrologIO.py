import time,os,subprocess
import DistanceMatrix
def beauty_print(a):
    print("No inicial : {}".format(a[0]))
    print("Caminho: {}".format(a[1]))
    print("Tempo de execucao: {}".format(a[2]))

stamp=time.strftime('%a%d%b%Y%H%M%S')
stampedname="regras"+stamp
stampedfilecega="buscacega"+stamp+".out"
stampedfilea="buscaa"+stamp+".out"
cities=['Ribeirao Preto','Bauru','Rifaina','Maringa','Cravinhos']
b=DistanceMatrix.construct_rules(stampedname+".pl","AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
argstring='consult({}),consult({}),open(\'{}\',write,Stream),{}(X,Y,Z),write(Stream,X),nl(Stream),write(Stream,Y),nl(Stream),write(Stream,Z),close(Stream),halt.'
subprocess.call(['swipl','--quiet','-t',argstring.format(stampedname,'buscacega_profundidade',stampedfilecega,'buscacega_profundidade')])
subprocess.call(['swipl','--quiet','-t',argstring.format(stampedname,'buscaInformada_A',stampedfilea,'buscaCaminho')])
a=[]
b=[]
with open(stampedfilecega,'r') as f:
    for line in f:
        buffer=line
        a.append(buffer)

with open(stampedfilea,'r') as f:
    for line in f:
        buffer=line
        b.append(buffer)
print("Busca cega \n")
beauty_print(a)
print("\n Busca A*\n")
beauty_print(b)
