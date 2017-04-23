/*
O PROBLEMA PODE SER MODELADO DA A PARTIR DA SEGUINTE REGRA:
pode_ir(cidade_origem,cidade_destino,custo).
EM QUE O CUSTO PODE SER A DISTANCIA OU O TEMPO DE VIAGEM.
*/

/*Busca não informada. */
caminho_cegoBPBackward(I,F,Cam):-
	caminho_b(I,[F],Cam).
	caminho_b(I,[I|Caminho],[I|Caminho]).
	caminho_b(I,[Ult_Estado|Caminho_ate_agora],Cam):-
		pode_ir(Est,Ult_Estado),
		not(pertence1(Est,Caminho_ate_agora)),
		caminho_b(I,[Est,Ult_Estado|Caminho_ate_agora],Cam).

pertence1(E,[E|_]):- !.
pertence1(E,[_|T]):-
pertence1(E,T).