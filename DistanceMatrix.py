# coding=utf-8
import googlemaps

def extract_distance_matrix(results):
    """ Filtra o resultado da api e devolve uma matriz"""

    a=[]
    for row in results["rows"]:
        b=[]
        for value in row['elements']:
            b.append(value['distance']['value'])
        a.append(b)
    return a

def places_distance_matrix(apikey, Places):
    """Constroi Matriz de conectivdade de todos os elementos usando a Api do maps"""
    gmaps= googlemaps.Client(key=apikey)
    results=gmaps.distance_matrix(Places,Places)
    return (extract_distance_matrix(results))

def construct_rules(File,apikey,Places):
    """Constroi as regras de Prolog apartir da matriz de conectividade """
    distance_matrix= places_distance_matrix(apikey,Places)
    with open(File,'w') as f:
        for i,origin in enumerate(Places):
            for j,destination in enumerate(Places):
                if(origin!=destination):
                    tempstring="pode_ir(\'{}\',\'{}\',{}).\n"
                    f.write(tempstring.format(origin,destination,distance_matrix[i][j]))
    return distance_matrix

def test_distance_matrix(apikey):
    """ Teste da funcao places_distance_matrix"""
    cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
    a= places_distance_matrix(apikey,cities)
    print(a)

def test_construct_rules(apikey):
    cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
    b=construct_rules("regras.pl",apikey,cities)
