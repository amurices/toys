from bs4 import BeautifulSoup
import sys
import requests

icao = input('Digite o código ICAO do aeródromo que quer consultar: ')
icao = icao.upper()

# Recuperar a página em forma HTML
url = 'https://www.aisweb.aer.mil.br/'
page = requests.get(url + '?i=aerodromos&codigo=' + icao)
# Parsear com BeautifulSoup
soup = BeautifulSoup(page.content, "html.parser")

# id = "cartas" identifica a parte da página com as informações relevantes às cartas.
cartas = soup.find(id="cartas")
# Usaremos 'cartas' como teste. Se o parser não encontrar nenhuma tag com o atributo id="cartas",
# então não existe uma página desse código ICAO para ser visitada.
if cartas == None:
    sys.exit("Aeródromo de código " + icao + " não existe ou cadastro sendo aguardado.")

# id = "meteoro" identifica a parte da página com as informações meteorológicas relevantes.
meteoro = soup.find(id="meteoro")
# idem para id = "sol".
sol = soup.find(id="sol")


print ("\n\nCartas:\n----------")
# Checa-se o campo de texto da primeira tag 'p' encontrada, que indica se há cartas ou não.
ha_cartas = cartas.find_all("p")
if ha_cartas != []:
    print (ha_cartas[0].get_text())
# Busca-se por tags "table" no HTML fonte, onde os dados das cartas estão contidos.
categorias = cartas.find_all("table")
for cats in categorias:
    # Cada tabela corresponde a uma categoria de carta. Dentro das categorias, busca-se por cartas
    cartas = cats.find_all("td")
    links = cats.find_all("a")

    data = False    # imprimir data ou não
    li = 0          # índice do link
    for carta in cartas:
        # Dentro de uma tag correspondendo a uma carta, há dois conteúdos de texto: data
        if data:
            print("Data:\t\t\t" + carta.get_text())
            print("Link para download:\t" + url + links[li]['href'])
            print("----------")
            li += 1
            data = False
        # e título. Como toda carta tem ambos, alterna-se o valor da booleana 'data' definida acima
        else:
            print("Título:\t\t\t" + carta.get_text()[:-1])
            data = True

print("\n\nNascer e pôr do sol\n----------")
# Arquitetura do site é tal que dentro da árvore <div id="sol">, há quatro tags strong:
# Duas correspondendo ao nascer e por do sol de hoje, e duas dos de amanhã.
horas = sol.find_all("strong")
print ("Sol nasce às", horas[0].get_text(), "e se põe às", horas[1].get_text())

# Analogamente à seção acima, parsear o HTML da página de um aeródromo faz com que a árvore
# correspondente à seção de informações TAF e METAR esteja dentro de tags "span".
print("\n\nMETAF e TAR:\n----------")
metar_taf = meteoro.find_all("span")
print ("Informação METAR:\n", metar_taf[0].get_text(), sep='')
print ("Informação TAF:\n", metar_taf[1].get_text(), sep='')
