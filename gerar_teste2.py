from random import randint

with open("teste_desempenho2.pl",'w') as f:
        for i in range(2,12):
	    f.write("\n")
            for j in range(1,i):
	            for k in range(1,i):
	                if(k!=j):
			    number = randint(1,1000)
	                    f.write("pode_ir({},{},{}).\n".format(j,k,number))
			    f.write("linha_reta({},{},{}).\n".format(j,k,number/2))

