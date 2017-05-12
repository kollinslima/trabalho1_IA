import time,os,subprocess
import DistanceMatrix
stamp=time.strftime('%a%d%b%Y%H%M%S')
stampedname="regras"+stamp
stampedfilecega="buscacega"+stamp+".out"
stampedfilea="buscaa"+stamp+".out"
cities=['Ribeirao Preto','Sao Carlos','Serrana','Bauru','Rifaina','Maringa','Cravinhos']
b=DistanceMatrix.construct_rules(stampedname+".pl","AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
argstring='consult({}),consult({}),open(\'{}\',write,Stream),{}(X,Y,Z),write(Stream,X),nl(Stream),write(Stream,Y),nl(Stream),write(Stream,Z),close(Stream),halt.'
subprocess.call(['swipl','--quiet','-t',argstring.format(stampedname,'buscacega_profundidade',stampedfilecega,'buscacega_profundidade')])
subprocess.call(['swipl','--quiet','-t',argstring.format(stampedname,'buscaInformada_A',stampedfilea,'buscaCaminho')])
#f= open(a,'w')
