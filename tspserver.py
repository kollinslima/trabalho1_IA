from flask import Flask
from flask import render_template
from flask import request
from PrologIO import ResultadoBuscas
from unidecode import unidecode
import re
app= Flask(__name__)

@app.route('/',methods=['GET','POST'])
def index():
    apikey="AIzaSyDnQndjPZDiERjXPdOmA5TAy5sVzk2rFqc"
    error=None
    if request.method =='POST':
        #Filtrando entrada recebida do usuário
        a=request.form['resultado'].strip('\[\"')
        a=a.strip('\]\"')
        b=re.split('\"\,\"',a)
        c=[re.sub('\,','',a) for a in b]
        cidades=[unidecode(d) for d in c]
        busca=ResultadoBuscas(cidades,0,apikey)
        return render_template('results.html',busca=busca)
    return render_template('application.html')
