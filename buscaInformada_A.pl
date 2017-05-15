buscaCaminho(Inicio,Caminho,Tempo):-
   get_time(TempoInicial),
   calculaCusto(Inicio,FCusto),					%Calcula todos os custos a partir do nó inicial
   calculaAvaliacao(Inicio,FAvaliacao),				
   heuristica(FCusto,FAvaliacao,PossiveisCaminhos),		%Calcula todas as heuristicas a partir do nó inicial
   reordenaCaminhos(PossiveisCaminhos,CaminhosOrdenados),	%Coloca caminho ativo no topo da lista
   encontraNos(Nos),						%Recebe lista com todas as cidades (para saber condição de parada)
   buscaCaminho(Inicio,Caminho,CaminhosOrdenados,Nos),
   get_time(TempoFinal),
   Tempo is TempoFinal-TempoInicial,!.		

buscaCaminho(Inicio,CaminhoAtivo,[[_|CaminhoAtivo]|_],Nos):-
	verificaFim([Inicio|CaminhoAtivo],Nos).
   
buscaCaminho(Inicio,Caminho,[[CustoAtivo|CaminhoAtivo]|Outros],Nos):-
	removeElemento([[CustoAtivo|CaminhoAtivo]|Outros],[CustoAtivo|CaminhoAtivo],CaminhosRestantes),
	expandeCaminhoAtivo(CaminhosRestantes,[CustoAtivo|CaminhoAtivo],CaminhosExtendidos), 		
	eliminaCaminhosIrregulares(CaminhosExtendidos,CaminhosCorrigidos,Inicio), 			
	reordenaCaminhos(CaminhosCorrigidos,CaminhosOrdenados),
	buscaCaminho(Inicio,Caminho,CaminhosOrdenados,Nos).

%Calcula função de custo de todos os caminhos conectados à Cidade
calculaCusto(Cidade,FCusto):-
   findall([Y,X],pode_ir(Cidade,X,Y),FCusto).

%Calcula função de avaliaçao de todos os caminhos conectados à Cidade
calculaAvaliacao(Cidade,FAvaliacao):-
   findall([0,X],pode_ir(Cidade,X,_),FAvaliacao).


%Calcula função heuristica combinando FCusto e FAvaliacao em PossiveisCaminhos
heuristica([[Custo,Cidade]|CaudaC],[[Avaliacao,Cidade]|CaudaA],[[Heuristica,Cidade]|CaudaH]):-
	Heuristica is Custo+Avaliacao,
	heuristica(CaudaC,CaudaA,CaudaH).
	
heuristica([[Custo,Cidade]],[[Avaliacao,Cidade]],[[Heuristica,Cidade]]):-
	Heuristica is Custo+Avaliacao.


%Coloca caminho ativo no começo da lista
reordenaCaminhos(PossiveisCaminhos,[Melhor|Outros]):-
	menorHeuristica(PossiveisCaminhos,Melhor),
	removeElemento(PossiveisCaminhos,Melhor,Outros).


%Retorna caminho ativo
menorHeuristica([Melhor],Melhor).
menorHeuristica([[Custo1|Melhor1],[Custo2|_]],[Custo1|Melhor1]):-
	Custo1=<Custo2,!.
menorHeuristica([[Custo1|_],[Custo2|Melhor2]],[Custo2|Melhor2]):-
	Custo2<Custo1,!.
menorHeuristica([Caminho1|OutrosCaminhos],Melhor):-
	menorHeuristica(OutrosCaminhos,MelhorAux1),
	menorHeuristica([Caminho1,MelhorAux1],Melhor).


%Remove elemento Melhor de PossiveisCaminhos e gera Outros
removeElemento([Melhor|Outros],Melhor,Outros).
removeElemento([Cabeca|Cauda],Melhor,[Cabeca|Outros]):-
	removeElemento(Cauda,Melhor,Outros).


%Retorna todos as cidades do mapa
encontraNos(Nos):- 
	setof(TodasCidades,X^Y^pode_ir(TodasCidades,X,Y),Nos).


%Verifica se CaminhoAtivo é a solução.
verificaFim([],[]).
verificaFim([Cabeca|Cauda],Nos):-
	contemElemento(Cabeca,Nos),
	removeElemento(Nos,Cabeca,NovosNos),
	verificaFim(Cauda,NovosNos).


contemElemento(Elemento,[Elemento|_]).
contemElemento(Elemento,[_|Cauda]):-
	contemElemento(Elemento,Cauda).


%Concatena os novos caminhos possíveis a partir do caminho ativo
expandeCaminhoAtivo(CaminhosRestantes,[CustoAtivo|CaminhoAtivo],CaminhosExtendidos):-
	ultimoNo(CaminhoAtivo,Ultimo),
	calculaCusto(Ultimo,FCustoExtendido),					
	calculaAvaliacao(Ultimo,FAvaliacaoExtendida),				
	heuristica(FCustoExtendido,FAvaliacaoExtendida,PossiveisCaminhosExtendidos),	
	reconstroiCaminhos([CustoAtivo|CaminhoAtivo],PossiveisCaminhosExtendidos,CaminhosReconstruidos),
	concatenaLista(CaminhosRestantes,CaminhosReconstruidos,CaminhosExtendidos).


ultimoNo([E],E).
ultimoNo([_|Cauda],E):-
	ultimoNo(Cauda,E).


reconstroiCaminhos([CustoAtivo|CaminhoAtivo],[[CustoExtendido|CaminhoExtendido]],[[Custo|Caminhos]]):-
	Custo is CustoAtivo+CustoExtendido,
	concatenaLista(CaminhoAtivo,CaminhoExtendido,Caminhos).

reconstroiCaminhos([CustoAtivo|CaminhoAtivo],[[CustoExtendido|CaminhoExtendido]|OutrosCaminhosExtendidos],[[Custo|Caminhos]|OutrosCaminhos]):-
	Custo is CustoAtivo+CustoExtendido,
	concatenaLista(CaminhoAtivo,CaminhoExtendido,Caminhos),
	reconstroiCaminhos([CustoAtivo|CaminhoAtivo],OutrosCaminhosExtendidos,OutrosCaminhos).	


concatenaLista([],L,L).
concatenaLista([Cabeca1|Cauda1],L2,[Cabeca1|Cauda3]):-
	concatenaLista(Cauda1,L2,Cauda3).


%Elimina todos os caminhos expandidos que não podem ser caminhos finais, criando a lista CaminhosCorrigidos
eliminaCaminhosIrregulares([],[],_):-!.

eliminaCaminhosIrregulares(Caminhos,[],Inicio):-
	caminhoValido(Inicio,Caminhos,NovosCaminhos),
	tamanhoLista(NovosCaminhos,0).

eliminaCaminhosIrregulares(Caminhos,[CaminhoCorrigido|OutrosCorrigidos],Inicio):-
	caminhoValido(Inicio,Caminhos,CaminhoCorrigido),
	removeElemento(Caminhos,CaminhoCorrigido,NovosCaminhos),
	eliminaCaminhosIrregulares(NovosCaminhos,OutrosCorrigidos,Inicio).


%Retorna um caminho válido de Caminhos ou lista vazia.
caminhoValido(_,[],[]).

caminhoValido(Inicio,[[Custo|Caminho]|_],[Custo|Caminho]):-
	not(repeteElemento([Inicio|Caminho])),!.

caminhoValido(Inicio,[_|Cauda],CaminhoCorrigido):-
	caminhoValido(Inicio,Cauda,CaminhoCorrigido).


%True se há repetição
repeteElemento([]):-fail.
repeteElemento(Lista):-
	setof(Elemento,X^removeElemento(Lista,Elemento,X),Laux),
	tamanhoLista(Laux,Num),
	not(tamanhoLista(Lista,Num)).



tamanhoLista([],0).
tamanhoLista([_|Cauda],N):-tamanhoLista(Cauda,Naux), N is 1+Naux.
