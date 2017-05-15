buscacega_profundidade(I,Cam,TempoExecucao):-
     get_time(TempoInicial),
     findall(TamCaminho,busca_Caminho(I,F,_,_,TamCaminho),ListaTam),maxLista(ListaTam,TamCaminho_Max),
     findall(CustoCaminho,busca_Caminho(I,F,_,CustoCaminho,TamCaminho_Max),ListaCusto),minLista(ListaCusto,CustoCaminho_Min),
     busca_Caminho(I,F,Cam,CustoCaminho_Min,TamCaminho_Max),get_time(TempoFinal),!,TempoExecucao is TempoFinal-TempoInicial.

busca_Caminho(I,F,Cam,CustoTotal,Tamanho):-
     CustoInicial is 0,
     caminho(I,[F],Cam,[CustoInicial],CustoFinal),somaElem_Lista(CustoFinal,CustoTotal),tamLista(CustoFinal,Tamanho).
     caminho(I,[I|Caminho],[I|Caminho],CustoCaminho,CustoCaminho).
     caminho(I,[Ult_Estado|Caminho_ate_agora],Cam,[Ult_Custo|Custo_ate_agora],CustoFinal):-
      pode_ir(Est,Ult_Estado,Custo),
      not( pertence1(Est,Caminho_ate_agora)),
      caminho(I,[Est,Ult_Estado|Caminho_ate_agora],Cam,[Custo,Ult_Custo|Custo_ate_agora],CustoFinal).

%Tamanho da lista
tamLista([], 0):- !.
tamLista([_|L], T):- tamLista(L, X), T is X + 1.

%Verifica se uma elemento pertence a lista
pertence1(E,[E|_]):- !.
pertence1(E,[_|T]):-
 pertence1(E,T).

%Soma todos os elementos de uma lista
somaElem_Lista([],0).
somaElem_Lista([Elem|Cauda],Soma):-
     somaElem_Lista(Cauda,Som),
     Soma is Som+Elem.

%Menor elemento de uma lista
minLista([X],X).
minLista([X|Y],M):-
     minLista(Y,N),(X<N -> M=X;M=N).

%Maior elemento de uma lista
maxLista([X],X).
maxLista([X|Y],M):-
     maxLista(Y,N),(X>N -> M=X;M=N).
