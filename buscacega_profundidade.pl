pode_ir('Ribeirao Preto','Cravinhos',23672).
pode_ir('Ribeirao Preto','Batatais',43332).
pode_ir('Ribeirao Preto','Sao Carlos',101032).
pode_ir('Ribeirao Preto','Bauru',211071).
pode_ir('Ribeirao Preto','Rifaina',156374).
pode_ir('Ribeirao Preto','Maringa',555114).
pode_ir('Cravinhos','Ribeirao Preto',24676).
pode_ir('Cravinhos','Batatais',61233).
pode_ir('Cravinhos','Sao Carlos',93804).
pode_ir('Cravinhos','Bauru',203844).
pode_ir('Cravinhos','Rifaina',174276).
pode_ir('Cravinhos','Maringa',595815).
pode_ir('Batatais','Ribeirao Preto',42629).
pode_ir('Batatais','Cravinhos',60759).
pode_ir('Batatais','Sao Carlos',140510).
pode_ir('Batatais','Bauru',250549).
pode_ir('Batatais','Rifaina',119221).
pode_ir('Batatais','Maringa',594787).
pode_ir('Sao Carlos','Ribeirao Preto',103955).
pode_ir('Sao Carlos','Cravinhos',93597).
pode_ir('Sao Carlos','Batatais',140427).
pode_ir('Sao Carlos','Bauru',155948).
pode_ir('Sao Carlos','Rifaina',253470).
pode_ir('Sao Carlos','Maringa',547919).
pode_ir('Bauru','Ribeirao Preto',215133).
pode_ir('Bauru','Cravinhos',204775).
pode_ir('Bauru','Batatais',251605).
pode_ir('Bauru','Sao Carlos',150273).
pode_ir('Bauru','Rifaina',364647).
pode_ir('Bauru','Maringa',398686).
pode_ir('Rifaina','Ribeirao Preto',181360).
pode_ir('Rifaina','Cravinhos',199976).
pode_ir('Rifaina','Batatais',167844).
pode_ir('Rifaina','Sao Carlos',279727).
pode_ir('Rifaina','Bauru',389766).
pode_ir('Rifaina','Maringa',728442).
pode_ir('Maringa','Ribeirao Preto',554825).
pode_ir('Maringa','Cravinhos',595976).
pode_ir('Maringa','Batatais',595688).
pode_ir('Maringa','Sao Carlos',541473).
pode_ir('Maringa','Bauru',391994).
pode_ir('Maringa','Rifaina',708730).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tamanho da lista
tamLista([], 0):- !.
tamLista([_|L], T):- tamLista(L, X), T is X + 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Verifica se uma elemento pertence a lista
pertence1(E,[E|_]):- !.
pertence1(E,[_|T]):-
 pertence1(E,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Soma todos os elementos de uma lista
somaElem_Lista([],0).
somaElem_Lista([Elem|Cauda],Soma):-
     somaElem_Lista(Cauda,Som),
     Soma is Som+Elem.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Menor elemento de uma lista
minLista([X],X).
minLista([X|Y],M):-
     minLista(Y,N),(X<N -> M=X;M=N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Maior elemento de uma lista
maxLista([X],X).
maxLista([X|Y],M):-
     maxLista(Y,N),(X>N -> M=X;M=N).
