import googlemaps

#To do list 
#1- Discover how Matrix Api Works V
#2- Decode Matrix Response V
#3- Define nodes for search V
#4- Do the blind search 
#5 -Do the guided search
## Optional
#6- Plot everything with html/css/js and Jinja Template (d3js.org suggested)
#7- Wrap every piece of this puzzle with flask

def extract_distance_matrix(results):
    a=[]
    for row in results["rows"]:
        b=[]
        for value in row['elements']:
            b.append(( value['distance']['value'] ))
        a.append(b)
    return a


def  places_distance_matrix(ApiKey, Places):
    gmaps= googlemaps.Client(key=ApiKey)
    results=gmaps.distance_matrix(Places,Places)
    return (extract_distance_matrix(results))

def construct_rules(File,ApiKey,Places):
    Distance_Matrix= places_distance_matrix(ApiKey,Places)

    with open(File,'w') as f:
        for i,origin in enumerate(Places):
            for j,destination in enumerate(Places):
                if(origin!=destination):
                    f.write("pode_ir({},{},{})\n".format(origin,destination,Distance_Matrix[i-1][j-1]))


#pode_ir(cidade_origem,cidade_destino,custo).

##Test A
#cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
#a= places_distance_matrix("AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
#print(a)
##Test B
#cities=['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa']
#b=construct_rules("regras.pl","AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",cities)
