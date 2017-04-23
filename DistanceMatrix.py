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


##Test A
#a= places_distance_matrix("AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc",['Ribeirao Preto','Cravinhos','Batatais','Sao Carlos','Bauru','Rifaina','Maringa'])
#print(a)
