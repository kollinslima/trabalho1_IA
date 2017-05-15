# coding=utf-8
from geopy.distance import vincenty

def extract_latlong(result):
#Extrai Longitude e Latitude
    return result[0]

def places_straightline_matrix(ApiKey, Places):
    gmaps= googlemaps.Client(key=ApiKey)
    latlong=[]
    #Obtendo latitude e longitude
    for place in Places:
        results= gmaps.geocode(place)
        a=(results[0]["geometry"]["location"])
        latlong.append(a)
    #Calculando Distancia linha reta
    straightline_matrix=[]
    for origin in latlong:
        aux_vector=[]

        for destination in latlong:
            if(origin!=destination):
               aux_vector.append(int(vincenty((origin['lat'],origin['lng']),(destination['lat'],origin['lng'])).m))
            else:
               aux_vector.append(0) 
        straightline_matrix.append(aux_vector)
        aux_vector=[]

    return straightline_matrix

def construct_straightline_rules:
        StraightLine_Matrix=places_straightline_matrix(ApiKey,Places)
         for i,origin in enumerate(Places):
                     for j,destination in enumerate(Places):
                         if(origin!=destination):
                             #Precisa estar entre aspas para não ser usada como váriavel em prolog
                             f.write("linha_reta(\'{}\',\'{}\',{}).\n".format(origin,destination,StraightLine_Matrix[i][j]))


def test_distance_matrix():
    cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
    a= places_straightline_matrix("AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
    print(a)

def test_construct_straightline_rules():
    cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
    b=construct_rules("regras.pl","AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
