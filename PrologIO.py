import time,os,subprocess
import DistanceMatrix
import re
import os

class Busca:
    """Representa um metodo de busca"""
    def __init__(self,caminho,tempo):
        self.caminho=caminho
        self.tempo=tempo


class ResultadoBuscas:
    """Representa o resultado de todos os metodos de busca implementados """

    def __init__(self,cities,inicial,apikey):
        #Lista com Cidades
        self.cities=cities
        #Cidade de partida
        self.inicial=inicial
        #Usado para definir nomes em tempo de execução, necessário para não ter conflitos no server web
        stamp=time.strftime('%a%d%b%Y%H%M%S')
        stampedname="regras"+stamp
        stampedfilecega="buscacega"+stamp+".out"
        stampedfilea="buscaa"+stamp+".out"
        #Matriz de Conectividade e construindo as regras
        self.distancematrix=DistanceMatrix.construct_rules(stampedname+".pl",apikey,cities)
        #Definindo caminhos usando prolog:
        argstring='consult({}),consult({}),open(\'{}\',write,Stream),{}(\'{}\',Y,Z),write(Stream,X),nl(Stream),write(Stream,Y),nl(Stream),write(Stream,Z),close(Stream),halt.'
        subprocess.call(['swipl','--quiet','-t',argstring.format(stampedname,'buscacega_profundidade',stampedfilecega,'buscacega_profundidade',cities[inicial])])
        subprocess.call(['swipl','--quiet','-t',argstring.format(stampedname,'buscaInformada_A',stampedfilea,'buscaCaminho',cities[inicial])])
        #Lendo dos arquivos de output do prolog e salvando em elementos da classe
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
        #Manipulando a string para lista (e excluindo o primeiro no para padronizar Busca A* e Busca Cega)
        caminhotemp=re.split(',',a[1].strip('[]\n'))
        caminhotemp.pop(0)
        self.bcega=Busca(caminhotemp,a[2])
        caminhotemp=re.split(',',b[1].strip('[]\n'))
        self.baestrela=Busca(caminhotemp,b[2])
        #Salvando a distancia total da nossa solucao
        self.distancia=self.soma_caminho()
        #Limpando arquivos auxiliares
        os.remove(stampedfilea)
        os.remove(stampedfilecega)
        os.remove(stampedname+".pl")

    def soma_caminho(self):
        #Mapeamento das cidades 
        citiesdicio={j:i for i,j in enumerate(self.cities)}
        #Reinserindo No inicial no nosso caminho
        caminhocompleto=self.bcega.caminho
        caminhocompleto.insert(0,self.cities[self.inicial])
        soma=0
        for n,cidades in enumerate(caminhocompleto):
            #Queremos calcular a distancia entre o termo n e n+1, sem incluir do ultimo pro primeiro
            if(n!=len(caminhocompleto)-1):
                #Encontrando os indices correspondentes da matriz de conectividade
                cidadeorigem=citiesdicio[caminhocompleto[n]]
                cidadedestino=citiesdicio[caminhocompleto[n+1]]
                soma=soma+self.distancematrix[cidadeorigem][cidadedestino]
        return soma

    def test():
         a= ResultadoBuscas(['Maracana','Sao Paulo','Bebedouro','Matao'],0)
         print(a.cities,a.inicial,a.bcega.caminho,a.baestrela.tempo,a.soma_caminho())
         return
