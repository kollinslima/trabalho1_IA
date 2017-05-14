# Trabalho Busca Cega/Busca Informada

## Requerimentos

### Python  3

#### Ubuntu

`sudo apt-get install software-properties-common`

#### Arch Linux

`sudo pacman -S python3`

### Swi Prolog

#### Ubuntu

#### Arch Linux
`sudo pacman -S swi-prolog`

### Pip (Gerenciador de Pacotes Python)

Caso ainda não exista o comando `pip`, siga <a href="https://pip.pypa.io/en/stable/installing/"> estas instruções</a>

### Google Maps Python API

#### Usando Pip 
`sudo pip install googlemaps`

`sudo pip install geopy`
`sudo pip install flask`
`sudo pip install unidecode`
## Uso

Na pasta principal, defina quem é a aplicação flask:

`export FLASK_APP=tspserver.py`

Rode a aplicação:

`run flask`

Acesse-a via browser 

http://127.0.0.1:5000/
