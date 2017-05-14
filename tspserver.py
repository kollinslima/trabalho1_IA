from flask import Flask
from flask import render_template
from flask import request
from PrologIO import ResultadoBuscas
from unidecode import unidecode
import re
app= Flask(__name__)

@app.route('/',methods=['GET','POST'])
def index():
    error=None
    if request.method =='POST':
        a=request.form['resultado'].strip('\[\"')
        a=a.strip('\]\"')
        b=re.split('\"\,\"',a)
        c=[re.sub('\,','',a) for a in b]
        cidades=[unidecode(d) for d in c]
        # for i,a in enumerate(formatando):
        #     if(i%2!=0):
        #         cidades.append(a)
        #         print(a)
        busca=ResultadoBuscas(cidades,0)
        return render_template('results.html',busca=busca)

    return render_template('application.html')

# #       basic_interface() 

    # a= ResultadoBuscas(['Maringa','Sao Paulo','Bebedouro','Matao'],0)
    # return 'Distancia %d' % a.distancia
