# coding=utf-8
import googlemaps
from geopy.distance import vincenty

#To do list 
#1- Discover how Matrix Api Works V
#2- Decode Matrix Response V
#3- Define nodes for search V
#4- Do the blind search 
#5 -Do the guided search
## Optional
#6- Plot everything with html/css/js and Jinja Template (d3js.org suggested)
#7- Wrap every piece of this puzzle with flask

#Extrair Longitude E Latitude
#Calcular Distancia
def extract_distance_matrix(results):
    a=[]
    for row in results["rows"]:
        b=[]
        for value in row['elements']:
            b.append(( value['distance']['value'] ))
        a.append(b)
    return a

def extract_latlong(result):
    return result[0]

def  places_distance_matrix(ApiKey, Places):
    gmaps= googlemaps.Client(key=ApiKey)
    results=gmaps.distance_matrix(Places,Places)
    return (extract_distance_matrix(results))

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


def construct_rules(File,ApiKey,Places):
    Distance_Matrix= places_distance_matrix(ApiKey,Places)
#    StraightLine_Matrix=places_straightline_matrix(ApiKey,Places)
    with open(File,'w') as f:
        for i,origin in enumerate(Places):
            for j,destination in enumerate(Places):
                if(origin!=destination):
                    #Precisa estar entre aspas para não ser usada como váriavel em prolog
                    f.write("pode_ir(\'{}\',\'{}\',{}).\n".format(origin,destination,Distance_Matrix[i][j]))
        # for i,origin in enumerate(Places):
        #             for j,destination in enumerate(Places):
        #                 if(origin!=destination):
        #                     #Precisa estar entre aspas para não ser usada como váriavel em prolog
        #                     f.write("linha_reta(\'{}\',\'{}\',{}).\n".format(origin,destination,StraightLine_Matrix[i][j]))



##Test A
# cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
# a= places_straightline_matrix("AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
#print(a)
#print(a)
##Test B
#cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
#b=construct_rules("regras.pl","AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
