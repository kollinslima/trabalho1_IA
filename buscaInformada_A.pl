%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%REGRAS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
linha_reta('Ribeirao Preto','Cravinhos',18847).
linha_reta('Ribeirao Preto','Batatais',30687).
linha_reta('Ribeirao Preto','Sao Carlos',92809).
linha_reta('Ribeirao Preto','Bauru',126665).
linha_reta('Ribeirao Preto','Rifaina',121724).
linha_reta('Ribeirao Preto','Maringa',249206).
linha_reta('Cravinhos','Ribeirao Preto',18847).
linha_reta('Cravinhos','Batatais',49534).
linha_reta('Cravinhos','Sao Carlos',73961).
linha_reta('Cravinhos','Bauru',107818).
linha_reta('Cravinhos','Rifaina',140572).
linha_reta('Cravinhos','Maringa',230358).
linha_reta('Batatais','Ribeirao Preto',30687).
linha_reta('Batatais','Cravinhos',49534).
linha_reta('Batatais','Sao Carlos',123496).
linha_reta('Batatais','Bauru',157352).
linha_reta('Batatais','Rifaina',91037).
linha_reta('Batatais','Maringa',279893).
linha_reta('Sao Carlos','Ribeirao Preto',92809).
linha_reta('Sao Carlos','Cravinhos',73961).
linha_reta('Sao Carlos','Batatais',123496).
linha_reta('Sao Carlos','Bauru',33856).
linha_reta('Sao Carlos','Rifaina',214533).
linha_reta('Sao Carlos','Maringa',156397).
linha_reta('Bauru','Ribeirao Preto',126665).
linha_reta('Bauru','Cravinhos',107818).
linha_reta('Bauru','Batatais',157352).
linha_reta('Bauru','Sao Carlos',33856).
linha_reta('Bauru','Rifaina',248390).
linha_reta('Bauru','Maringa',122540).
linha_reta('Rifaina','Ribeirao Preto',121724).
linha_reta('Rifaina','Cravinhos',140572).
linha_reta('Rifaina','Batatais',91037).
linha_reta('Rifaina','Sao Carlos',214533).
linha_reta('Rifaina','Bauru',248390).
linha_reta('Rifaina','Maringa',370930).
linha_reta('Maringa','Ribeirao Preto',249206).
linha_reta('Maringa','Cravinhos',230358).
linha_reta('Maringa','Batatais',279893).
linha_reta('Maringa','Sao Carlos',156397).
linha_reta('Maringa','Bauru',122540).
linha_reta('Maringa','Rifaina',370930).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula função de custo de todos os caminhos conectados à Cidade
calculaCusto(Cidade,FCusto):-
   findall([Y,X],pode_ir(Cidade,X,Y),FCusto).

%Calcula função de avaliaçao de todos os caminhos conectados à Cidade
calculaAvaliacao(Cidade,FAvaliacao):-
   findall([0,X],pode_ir(Cidade,X,_),FAvaliacao).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcula função heuristica combinando FCusto e FAvaliacao em PossiveisCaminhos
heuristica([[Custo,Cidade]|CaudaC],[[Avaliacao,Cidade]|CaudaA],[[Heuristica,Cidade]|CaudaH]):-
	Heuristica is Custo+Avaliacao,
	heuristica(CaudaC,CaudaA,CaudaH).
	
heuristica([[Custo,Cidade]],[[Avaliacao,Cidade]],[[Heuristica,Cidade]]):-
	Heuristica is Custo+Avaliacao.
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
expandeCaminhoAtivo(CaminhosRestantes,[CustoAtivo|CaminhoAtivo],CaminhosExtendidos):-
	ultimoNo(CaminhoAtivo,Ultimo),
	calculaCusto(Ultimo,FCustoExtendido),					
	calculaAvaliacao(Ultimo,FAvaliacaoExtendida),				
	heuristica(FCustoExtendido,FAvaliacaoExtendida,PossiveisCaminhosExtendidos),	
	reconstroiCaminhos([CustoAtivo|CaminhoAtivo],PossiveisCaminhosExtendidos,CaminhosReconstruidos),
	concatenaLista(CaminhosRestantes,CaminhosReconstruidos,CaminhosExtendidos).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ultimoNo([E],E).
ultimoNo([_|Cauda],E):-
	ultimoNo(Cauda,E).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reconstroiCaminhos([CustoAtivo|CaminhoAtivo],[[CustoExtendido|CaminhoExtendido]],[[Custo|Caminhos]]):-
	Custo is CustoAtivo+CustoExtendido,
	concatenaLista(CaminhoAtivo,CaminhoExtendido,Caminhos).

reconstroiCaminhos([CustoAtivo|CaminhoAtivo],[[CustoExtendido|CaminhoExtendido]|OutrosCaminhosExtendidos],[[Custo|Caminhos]|OutrosCaminhos]):-
	Custo is CustoAtivo+CustoExtendido,
	concatenaLista(CaminhoAtivo,CaminhoExtendido,Caminhos),
	reconstroiCaminhos([CustoAtivo|CaminhoAtivo],OutrosCaminhosExtendidos,OutrosCaminhos).	
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
