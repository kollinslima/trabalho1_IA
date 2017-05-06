%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%REGRAS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pode_ir(1,2,1).
pode_ir(1,3,1).
pode_ir(1,4,1).
pode_ir(1,5,1).
pode_ir(2,1,1).
pode_ir(2,3,1).
pode_ir(2,4,1).
pode_ir(2,5,1).
pode_ir(3,1,1).
pode_ir(3,2,1).
pode_ir(3,4,1).
pode_ir(3,5,1).
pode_ir(4,1,1).
pode_ir(4,2,1).
pode_ir(4,3,1).
pode_ir(4,5,1).
pode_ir(5,1,1).
pode_ir(5,2,1).
pode_ir(5,3,1).
pode_ir(5,4,1).
linha_reta(1,2,0.5).
linha_reta(1,3,0.5).
linha_reta(1,4,0.5).
linha_reta(1,5,0.5).
linha_reta(2,1,0.5).
linha_reta(2,3,0.5).
linha_reta(2,4,0.5).
linha_reta(2,5,0.5).
linha_reta(3,1,0.5).
linha_reta(3,2,0.5).
linha_reta(3,4,0.5).
linha_reta(3,5,0.5).
linha_reta(4,1,0.5).
linha_reta(4,2,0.5).
linha_reta(4,3,0.5).
linha_reta(4,5,0.5).
linha_reta(5,1,0.5).
linha_reta(5,2,0.5).
linha_reta(5,3,0.5).
linha_reta(5,4,0.5).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Heuristica da incerção mais barata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buscaCaminho(Inicio,Caminho,Tempo):-
   get_time(TempoInicial),
   calculaCusto(Inicio,FCusto),					%Calcula todos os custos a partir do nó inicial
   concatenaLista([],[Inicio],CaminhoAtivo),
   calculaAvaliacao(FCusto,CaminhoAtivo,FAvaliacao),				
   heuristica(FCusto,FAvaliacao,PossiveisCaminhos),		%Calcula todas as heuristicas a partir do nó inicial
   reordenaCaminhos(PossiveisCaminhos,CaminhosOrdenados),	%Coloca caminho ativo no topo da lista
   alinhaCusto(CaminhosOrdenados,FCusto,FCustoOrdenado),	%Alinha caminho selecionado como ativo para inicio da lista
   encontraNos(Nos),						%Recebe lista com todas as cidades (para saber condição de parada)
   buscaCaminho(Inicio,Caminho,CaminhosOrdenados,Nos,FCustoOrdenado),
   get_time(TempoFinal),
   Tempo is TempoFinal - TempoInicial,!.		

buscaCaminho(Inicio,CaminhoAtivo,[[_|CaminhoAtivo]|_],Nos,_):-
	verificaFim([Inicio|CaminhoAtivo],Nos).
   
buscaCaminho(Inicio,Caminho,[[CustoAtivo|CaminhoAtivo]|Outros],Nos,[[CustoAnterior|CidadesAnteriores]|OutrosAnteriores]):-
	removeElemento([[CustoAtivo|CaminhoAtivo]|Outros],[CustoAtivo|CaminhoAtivo],CaminhosRestantes),
	removeElemento([[CustoAnterior|CidadesAnteriores]|OutrosAnteriores],[CustoAnterior|CidadesAnteriores],FCustoRestante),
	expandeCaminhoAtivo(CaminhosRestantes,[CustoAtivo|CaminhoAtivo],CaminhosExtendidos,FCustoRestante,[CustoAnterior|CidadesAnteriores],FCustoExtendido,Inicio), 		
	eliminaCaminhosIrregulares(CaminhosExtendidos,CaminhosCorrigidos,Inicio), 			
	eliminaCaminhosIrregulares(FCustoExtendido,FCustoCorrigido,Inicio),
	reordenaCaminhos(CaminhosCorrigidos,CaminhosOrdenados),
	alinhaCusto(CaminhosOrdenados,FCustoCorrigido,FCustoOrdenado),
	buscaCaminho(Inicio,Caminho,CaminhosOrdenados,Nos,FCustoOrdenado).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alinha caminho selecionado como ativo para inicio da lista
alinhaCusto([[_|CaminhoAtivo]|_],[[Custo|CaminhoAtivo]|OutrosCustos],[[Custo|CaminhoAtivo]|OutrosCustos]).

alinhaCusto([[_|CaminhoAtivo]|_],[Custo|OutrosCustos],FCustoOrdenado):-
	alinhaCusto([[_|CaminhoAtivo]|_],OutrosCustos,Laux),
	concatenaLista(Laux,[Custo],FCustoOrdenado).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula função de custo de todos os caminhos conectados à Cidade
calculaCusto(Cidade,FCusto):-
   findall([Y,X],pode_ir(Cidade,X,Y),FCusto).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula função de avaliaçao de todos os caminhos conectados à Cidade
calculaAvaliacao([],_,[]).

calculaAvaliacao([CabecaCusto|CaudaCusto],CaminhoAtivo,[[CustoA,Ultimo]|CaudaAvaliacao]):-
   ultimoNo(CabecaCusto,Ultimo),   
   findall([Y,X],linha_reta(Ultimo,X,Y),Aux),
   menorCusto(Aux,CustoA),
   calculaAvaliacao(CaudaCusto,CaminhoAtivo,CaudaAvaliacao).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula o menor custo da lista.
menorCusto([[Custo,_]],Custo):-!.
menorCusto([[Custo1,_],[Custo2,_]],Custo1):-Custo1=<Custo2,!.
menorCusto([[Custo1,_],[Custo2,_]],Custo2):-Custo2<Custo1,!.
menorCusto([[Custo1,No1]|Outros],CabecaAvaliacao):-
	menorCusto(Outros,CabecaAux),
	menorCusto([[Custo1,No1],[CabecaAux,_]],CabecaAvaliacao).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula custo dos caminhos adicionado ao custo para chegar ao último No
calculaCustoAcumulado(Ultimo,FCustoAcumulado,[CustoAnterior|CidadesAnteriores]):-
	findall(A,(pode_ir(Ultimo,X,Y),Z is Y+CustoAnterior,concatenaLista(CidadesAnteriores,[X],W),adicionaElementoInicio(W,Z,A)),FCustoAcumulado).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
adicionaElementoInicio([Cabeca|Cauda],E,[E,Cabeca|Cauda]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula função heuristica combinando FCusto e FAvaliacao em PossiveisCaminhos
heuristica([[Custo|_]],[[Avaliacao,Cidade]],[[Heuristica,Cidade]]):-
	Heuristica is Custo+Avaliacao.

heuristica([[Custo|CaminhoC]|CaudaC],FAvaliacao,[[Heuristica,UltimoC]|CaudaH]):-
	ultimoNo(CaminhoC,UltimoC),
	buscaAvaliacao(UltimoC,FAvaliacao,Avaliacao),
	Heuristica is Custo+Avaliacao,
	removeElemento(FAvaliacao,[Avaliacao,UltimoC],CaudaA),
	heuristica(CaudaC,CaudaA,CaudaH).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Busca valor da função de avaliação, fazendo uma busca na lista
buscaAvaliacao(UltimoC,[[Avaliacao,UltimoC]|_],Avaliacao).
buscaAvaliacao(UltimoC,[_|Cauda],Avaliacao):-
	buscaAvaliacao(UltimoC,Cauda,Avaliacao).	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Coloca caminho ativo no começo da lista
reordenaCaminhos(PossiveisCaminhos,[Melhor|Outros]):-
	menorHeuristica(PossiveisCaminhos,Melhor),
	removeElemento(PossiveisCaminhos,Melhor,Outros).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Retorna caminho ativo
menorHeuristica([Melhor],Melhor).
menorHeuristica([[Custo1|Melhor1],[Custo2|_]],[Custo1|Melhor1]):-
	Custo1=<Custo2,!.
menorHeuristica([[Custo1|_],[Custo2|Melhor2]],[Custo2|Melhor2]):-
	Custo2<Custo1,!.
menorHeuristica([Caminho1|OutrosCaminhos],Melhor):-
	menorHeuristica(OutrosCaminhos,MelhorAux1),
	menorHeuristica([Caminho1,MelhorAux1],Melhor).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Remove elemento Melhor de PossiveisCaminhos e gera Outros
removeElemento([Melhor|Outros],Melhor,Outros).
removeElemento([Cabeca|Cauda],Melhor,[Cabeca|Outros]):-
	removeElemento(Cauda,Melhor,Outros).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Retorna todos as cidades do mapa
encontraNos(Nos):- 
	setof(TodasCidades,X^Y^pode_ir(TodasCidades,X,Y),Nos).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Verifica se CaminhoAtivo é a solução.
verificaFim([],[]).
verificaFim([Cabeca|Cauda],Nos):-
	contemElemento(Cabeca,Nos),
	removeElemento(Nos,Cabeca,NovosNos),
	verificaFim(Cauda,NovosNos).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contemElemento(Elemento,[Elemento|_]).
contemElemento(Elemento,[_|Cauda]):-
	contemElemento(Elemento,Cauda).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Concatena os novos caminhos possíveis a partir do caminho ativo
expandeCaminhoAtivo(CaminhosRestantes,[CustoAtivo|CaminhoAtivo],CaminhosExtendidos,FCustoRestante,[CustoAnterior|CidadesAnteriores],FCustoExtendido,Inicio):-
	ultimoNo(CaminhoAtivo,Ultimo),
	concatenaLista(CaminhoAtivo,[Inicio],CaminhoAtivoAux),
	calculaCustoAcumulado(Ultimo,FCustoAcumulado,[CustoAnterior|CidadesAnteriores]),	        
	calculaAvaliacao(FCustoAcumulado,CaminhoAtivoAux,FAvaliacaoExtendida),				
	heuristica(FCustoAcumulado,FAvaliacaoExtendida,PossiveisCaminhosExtendidos),	
	reconstroiCaminhos([CustoAtivo|CaminhoAtivo],PossiveisCaminhosExtendidos,CaminhosReconstruidos),
	concatenaLista(CaminhosRestantes,CaminhosReconstruidos,CaminhosExtendidos),
	concatenaLista(FCustoRestante,FCustoAcumulado,FCustoExtendido).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ultimoNo([E],E).
ultimoNo([_|Cauda],E):-
	ultimoNo(Cauda,E).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Acumula a função heurística nos novos caminhos
reconstroiCaminhos([_|CaminhoAtivo],[[CustoExtendido|CaminhoExtendido]],[[CustoExtendido|Caminhos]]):-
	concatenaLista(CaminhoAtivo,CaminhoExtendido,Caminhos).

reconstroiCaminhos([_|CaminhoAtivo],[[CustoExtendido|CaminhoExtendido]|OutrosCaminhosExtendidos],[[CustoExtendido|Caminhos]|OutrosCaminhos]):-
	concatenaLista(CaminhoAtivo,CaminhoExtendido,Caminhos),
	reconstroiCaminhos([_|CaminhoAtivo],OutrosCaminhosExtendidos,OutrosCaminhos).	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
concatenaLista([],L,L).
concatenaLista([Cabeca1|Cauda1],L2,[Cabeca1|Cauda3]):-
	concatenaLista(Cauda1,L2,Cauda3).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Elimina todos os caminhos expandidos que não podem ser caminhos finais, criando a lista CaminhosCorrigidos
eliminaCaminhosIrregulares([],[],_):-!.

eliminaCaminhosIrregulares(Caminhos,[],Inicio):-
	caminhoValido(Inicio,Caminhos,NovosCaminhos),
	tamanhoLista(NovosCaminhos,0).

eliminaCaminhosIrregulares(Caminhos,[CaminhoCorrigido|OutrosCorrigidos],Inicio):-
	caminhoValido(Inicio,Caminhos,CaminhoCorrigido),
	removeElemento(Caminhos,CaminhoCorrigido,NovosCaminhos),
	eliminaCaminhosIrregulares(NovosCaminhos,OutrosCorrigidos,Inicio).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Retorna um caminho válido de Caminhos ou lista vazia.
caminhoValido(_,[],[]).

caminhoValido(Inicio,[[Custo|Caminho]|_],[Custo|Caminho]):-
	not(repeteElemento([Inicio|Caminho])),!.

caminhoValido(Inicio,[_|Cauda],CaminhoCorrigido):-
	caminhoValido(Inicio,Cauda,CaminhoCorrigido).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%True se há repetição
repeteElemento([]):-fail.
repeteElemento(Lista):-
	setof(Elemento,X^removeElemento(Lista,Elemento,X),Laux),
	tamanhoLista(Laux,Num),
	not(tamanhoLista(Lista,Num)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tamanhoLista([],0).
tamanhoLista([_|Cauda],N):-tamanhoLista(Cauda,Naux), N is 1+Naux.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
