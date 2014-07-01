=============
TESTUINGURUA
=============

Testuzko informazioa modu trinkoan gorde nahi bada, luzera finkoko karaktereen kodeketa alde batetara utzi behar dugu eta, aldiz, karaktereen agerpen-maiztasunean oinarritutako kodeketara jo. Hau, testuan maizen agertzen diren karaktereek luzera motzen duten kodeketa-hitzak emanez lortzen da.
Honela, “arrastoa” hitza soilik bagenu eta honi legokiokeen kodeketa bat::


  'a'-->0         't'-->110           's'-->1111
  'r'-->10        'o'-->1110

izanik, “arrastoa” kodetuko lukeen biten sekuentzia  01010011 11110111 00 izango litzateke. Hau, jatorrizkoa baino luzeagoa 
izan arren, paketatze prozesu bat aplikatuz kodeketa trinkoagoa lortzen da, hauxe izanik bidaltzen dena makina batetik bestera. 
Ondoren, helmuga makinan alderantzizko pausoak ematen dira. Gure adibideari heutsiz, adibidez, izango genukeena litzateke::

    arrastoa    0101001 1111101 1100      )}`   0101001 1111101 1100    arrastoa
    Kodeketa    Trinkoketa  Destrinkoketa   Deskodeketa


Gure kasurako, eta sinplifikatzearren, trinkoketa/destrinkoketa pausoak alde batetara utziko ditugu eta kodeketa/deskodeketa 
prozesuetan oinarrituko.

Deskodeteta modu bakarrean ulergarria izan dadin, kodeketa-hitzak ezin dira edozein modutan aukeratu. Eta hori, kodeketa-hitz
bakoitzak beste hitzen “aurrezkiak” ez direnean lortzen da. Propietate hau betetzen duten kodeketa metodoei aurrekodeketa 
metodoak deritze.

Bestalde, kodeketa optimoa izatea nahi da, hots, testu kodifikatuaren luzera minimoa izatea. Zehazki, Kj (1<j<n) n karaktere i
zanik, non haien agerpen-maiztasunak Mj diren eta Lj luzerak dituzten kodeak aukeratzen badira testua kodetzeko, jatorrizko 

Aurrekodeketa optimoa sortzen duen metodo bat Huffman kodeketa da.

Huffman kodeak (metodoa aplikatzearen emaitza) testuen karaktereak banaka-banaka kodetzen dituzten 0en eta 1en sekuentziak dira,
non jatorrizko testuan maizen agertzen diren karaktereei esleitutako kodeketa-hitzak hitz motzenak diren. (Argipen gehiago:
sarean edo “Algoritmika”-ko liburuan pp. [129-137] ikus).


Praktika honetan testu fitxategi bat emanik Huffman kodeketa/deskodeketa prozesuak aplikatuko dizkiogu, lehenen Huffman 
zuhaitza eraikiko dugu kodeketa-hitzak mugatzeko; ondoren, zuhaitza hau erabiliz jatorrizko testua kodifikatuko dugu; eta 
azkenik, kodifikaziotik eta eraikitako Huffman zuhaitza erabiliz, jatorrizko testua berreskuratuko dugu. Hori dena lortzeko,
praktika 5 fasetan banatu dizuet, fase bakoitzean egin behar duzuena zehazturik ematen dizuet.

1 fasea
==========

Helburua:   Karaktere zerrenda bat emanik (Karaktere,Maiztasuna) bikoteen zerrenda ordenatua lortu behar da, non sarrerako
karaktere desberdin bakoitzeko bikote bat existituko duen emaitza zerrendan (k,m) bikotea, k karakterea adieraziko duelarik 
eta m k karraktere hori sarrerako stringan agertzen den aldi kopurua jasoko duen. Bikoteen emaitza-zerrenda bikoteko bigarren
osagaiarekiko (hots, maiztasunarekiko) ordena gorakorrean ordenaturik egon behar du.
    
Oharra:
    
Efektu hori kalkulatuko duen funtzioaren zehaztapena honako hau da::

   scanTestua:: String -> [(Char,Int)]

* (A) aukera: Zerrendak erabiliaz. Zenbat eta stringa luzeagoa izan orduan eta motelago da soluzio hau. Prozesua honakoa izan
liteke, adibidez::

  Stringeko karaktere bakoitzarik 1 balioa esleitu::
  *:: String -> [(Char,Int)]
  "arrakasta" - [(‘a’,1),(‘r‘,l),(‘r’,1),(‘a’,1),(‘k’,1),(‘a’,1),(‘s’,1),(‘t’,1),(‘a’,1)]
  bikoteen kate berriko balioak bikoteko lehen balioarekiko ordenatu::
 
 *:: [(Char,Int)]-> [(Char,Int)]
 [(‘a’,1), (‘a’,1), (‘a’,1), (‘a’,1), (‘k’,1), (‘r‘,l), (‘r’,1), (‘s’,1), (‘t’,1)]
 
Karaktere berdinak dituzten kodeak bikote bakar batean bat egin, bikoteko lehenengoa karakterea izanik eta bigarrena haren
agerpen maiztasuna (bat egin diren bikote kopurua) izanik::

  *:: [(Char,Int)]-> [(Char,Int)]
  [(‘a’,4), (‘k’,1), (‘r‘,2), (‘s’,1), (‘t’,1)]

Oharra: Gakodun osagaiez osatutako zerrenda ordenatzeko MergeSort ordenazio algoritmoa erabil ezazue argumentu bat gehiagorekin, gakoaLortu funtzioa, non funtzio horrek zerrendako osagai bat emanik osagaiko gakoa itzuliko duen.


* (B) aukera: AVL zuhaitz bitar orekatuak erabili. Zuhaitzeko osagaiak (Karakterea, Agerpen-Maiztasuna). Prozesua honakoa izan 
liteke, adibidez:

 Sarrerako stringeko karaktereekin AVLa eraikitzen joan:
    * :: String -> AVL [(Char,Int)]
    Tratatzen ari garen sarrerako K karakterea
    baldin lehenengo aldia da agertzen dela, orduan AVL zuhaitzari (K,1) bikotea gehitzen zaio.
    baldin aurrez noizbait K agertu bada, eta ondorioz AVL zuhaitzean (K,N) bikoteak existitzen du, orduan AVL zuhaitzeko (K,N) kotea (K,N+1) bikoteaz ordezkatu.
    AVL zuhaitza lautu, sarrerako karaktere desberdinen eta haien maiztasunak bikoteetan jasota dituen zerrenda lortzeko
    * :: AVL [(Char,Int)] -> [(Char,Int)]

2 fasea
=============

Helburua:   jatorrizko stringari dagokion HuffmanZu zuhaitza eraiki, maiztasunen zerrendak erabiliz. Efektu hori kalkulatuko 
duen funtzioaren zehaztapena honako hau da::

  huffZu:: String -> HuffmanZu

    “arrakasta”             “arrosali”
    [(‘a’,4),(‘k’,1),(‘r‘,2),(‘s’,1),(‘t’,1)]           [(‘a’,2),(‘i’,1),(‘l’,1),(‘r‘,2),(‘s’,1)]

    
    'a'0       'k'1110            'a'00      's'101
    'r'10      's'1111            'r'01      'i'110
    't'110                     'o'100 'l'111

Maiztasun handienak dituzten karaktereei kodeketa-hitz txikienak dagozkie, eta zuhaitzean gorago agertzen dira.
Zuhaitza interpretatzeko garaian: ezkerreko adarra 0 eta eskuineko adarra 1

Prozesua:   HuffmanZu zuhaitzen zerrenda ordenatu bat maneiatuko du prozesuak. Ordenazioaren irizpide edo gakoa, HuffmanZu zuhaitz bakoitzaren erroan dagoen maiztasun-balioa da.

(Karaktere, Maiztasun) bikoteen zerrenda, HuffmanZu hostoen zerrenda ordenatua bihur ezazue. Ordenazio ordenak gorakorra izan behar du, eta irizpidea goian aipaturikoa, hau da, erroetako maiztasunen balioekikoa. 1 faseko (A) aukeran aipatutako MergeSort metodoa erabili ezazue eta hari pasa behar diozuen gakoLortu funtzio egokia defini:
* :: [(Char,Int)] -> [HuffmanBT]
 [(HP (‘k’,1)), (HP (‘s’,1)), (HP (‘t‘,1)), (HP (‘r’,2)) ,(HP (‘a’,4)]

Zuhaitzen zerrendak zuhaitz bat baino gehiago duen bitartean egizue:
HuffmanZu zerrendako maiztasun txikien duten bi zuhaitzak lortu; hots, zerrendako lehengo biak, izan bitez t1 eta t2, eta zerrendatik ezaba itzazue.
HuffmanZu zuhaitz berri bat eraiki, izan bedi t12 zuhaitza: ezkerreko azpizuahitza t1 izango du eta eskuinekoa t2, eta bere erroan azpizuhaitz bien erroetako maiztasunen batura jasoko du.
HuffmanZu zuhaitzen zerrenda ordenatuan eta ordenazio irizpide berdina erabiliz t12 txerta ezazu zerrenda ordenatua utziaz.
 [ (HP (‘t‘,1)),   (EP 2),  (HP (‘r’,2)) ,(HP (‘a’,4)]

(HP (‘k’,1)), (HP (‘s’,1)),

Zuhaitzen zerrendak osagai bakarra duenean, hura itzuli
* :: [HuffmanZu] ->HuffmanZu
3 fasea)
Helburua:   jatorrizko testua edo stringa kodetu, HuffmanZu zuhaitza erabiliz
Efektu hori kalkulatuko duen funtzioaren zehaztapena honako hau da:
type Kode = String          -- ‘0’ eta ‘1’ karaktereez osatua
kodetu:: String -> HuffmanZu-> Kode

Prozesua:
Huffman zuhaitzetik abiaturik kodeketa-hitzen taula lortu behar duzue lehenen. Hau da, sarrerako karaktere desberdin bakoitza ordezkatuko duen ‘0’ edo ’1’ karaktereen zerrenda. Taula, bikoteen zerrenda bat izango da, non bikotekeko lehenengo osagaia karakterea izango den eta bigarrena hari dagokion kodeketa-hitza.
Zuhaitzak dituen adar adina kodeketa-hitz lortu behar dituzue.
Hosto bakoitza kodetu behar den karaktere desberdin bat da.
Karaktere bakoitzak kodetzeko erabiliko den kodeketa-hitzak, zuhaitzaren errotik hostoraino doan bideak ematen du:
Hasieran kodeketa hitza hutsik dago
Adarkatzea ezkerretara gertatzen denean, orain arte lortu den kodeketari ‘0’ gehitzen zaio.
Adarkatzea eskuinetara gertatzen denean, orain arte lortu den kodeketari ‘1’ gehitzen zaio.
Hostora iristean, kodeketa-hitzaren eraikuntza amaitzen da

*:: HuffmanZ -> [(Char, Kode)]

Aurreko ataleko bikoteen zerrenda ordenatu behar duzue, oraingoan zerrendako bigarren osagaiaren luzerarekiko, kodeketa-hitz motzenak hasieran eta luzeenak amaieran utziaz:
Jatorrizko stringa kodeketa-hitzen taula erabiliz kodetu.

“arrakasta” “0101001110011111100”


Oharra: Kodetu nahi den testua nahiko handia denean, ordua
n
length (kodetu ...) div 7 <<< length sarrerakoTestua

    bete behar da, bestela aurrizki kodeketa optimoa ez duzue sortu!!!!!


4 fasea)
Helburua:   aurreko faseko alderantzizko efektua lortu. Derrigorrezkoa da kodetzeko erabili den zuhaitz bera erabiltzea desegite prozesuan.
Efektu hori kalkulatuko duen funtzioaren zehaztapena honako hau da:

deskodetu:: HuffmanZu-> Kode -> String

Prozesua:
Kodifikazio sekuentziak dioen moduan, zuhaitza korritu behar da:
Sekuentzian ‘0’ bat badator, ezkerreko azpizuhaitzera jo behar da, baldin eta honek existitzen badu
Sekuentzian ‘1’ bat badator, eskuineko azpizuhaitzera jo behar da, baldin eta honek existitzen badu
Sekuentzian ‘0’ edo ‘1’ bat edukiz azpizuhaitzik existitzen ez badu, hosto batean zaudetelako da, eta orain arteko sekuentziak kodeketa-hitz bat osatzen du, hain zuzen, hostoan dagoen karaktereari dagokiona. Ondorioz, hostoko karakterea itzuli behar duzue.
Oraindik tratatu gabeko 0a edo 1a eta ondorengoak berriz ere Huffman zuhaitz osotik abiatuz deskodetu behar duzue
Prozesua amaitzen da kodeketa sekuentzia amaitzen denean

“arrakasta”    “0101001110011111100”+ HuffmanZu
       “a” “101001110011111100”
       “ar”    “1001110011111100”
       “arr”   “01110011111100”
       “arra”  “1110011111100”
       “arrak” ”011111100”
       “arraka”    “11111100”
       “arrakas”   “1100”
       “arrakast”  “0”
       “arrakasta” “”
       “arrakasta”

5 fasea)
Helburua:   aurreko faseetako kodea modulatu eta S/I geruza bat jarri kodeketa/deskodeketa prozesuak erabilgarriak izan daitezen.

Prozesua:
Huffmanen kodeketa moduluari izena eman (fitxategiri izen bera eman).
Modulu honek esportatuko dituen funtzioak izango dira soilik: huffZu, kodetu eta deskodetu.
Erosoago egitearren, funtzio hauen parametrizazioa aldatu eta, ondorioz, kodeak efektu bera eduki dezan, behar diren aldaketak egin:
huffZu:: String -> HuffmanZ
kodetu:: String -> (HuffmanZ,Kode)
deskodetu:: (HuffmanZ,Kode) -> String
Zuhaitz bitarren eta AVL modulu generikoen “inportazioa” egin modulu berritik.
Huffmanen kodeketak inplementatzen duen moduluari Sarrera/Irteerako geruza gain jartzeko beste modulu bat egizu: Izena eman eta aurreko ataleko inportatu
Eska iezaiozue erabiltzaileari honek kodetu nahi duen fitxategiaren izena, demagun xxx
Kodeketa irauli ezazue izen berdina baina K hizkiaz hasten fitxategira, Kxxx. Huffmanen kodeketa zuhaitza aldagai batean utz ezazue, fitxategira irauli gabe. Erabiltzaileari egindakoaren berri eman mezu baten bidez.
Kodeketa duen fitxategitik eta Huffmanen zuhaitza erabiliz, jatorrizko testua berreskuratu nahi duen erabiltzaileari galdetu. erantzuna ezezkoa bada, agurtu eta amaitu. Aldiz, baiezko bada, orduan izen berdina baina D hizkiaz hasten den fitxategira irauli ezazue deskodeketa, Dxxx, eta egindakoaren mezu emanaz erabiltzaileari, agurtu eta amaitu.
xxx eta Dxxx eduki berdina badute, amaitu duzue.


OHARRAK:
1) Zuhaitzak maneiatzen eta itzultzen dituzuen funtzioen zuzentasuna ikusteko deriving Show egitea guztiz kaskarra da, egizue zuhaitz desberdinentzat ikustaratze funtzio egokia/k.
2) MergeSort ordenazio metodo bakarra egitea eskatzen zaizue praktika osorako, hura ahalik eta generikoena izan beharko du, haren lortuGakoa parametro-funtzioaren egokitzapen desberdinek behar dituzuen ordenazioak eman ditzaten.
3) Enuntziatua eskatzen zaizuen derrigorrez funtzionatzen itzuli behar duzuen betebehar minimoa da. Hortik abiatuta hobekuntzak ongietorriak dira.
4) Egiten duzuen praktikaren dokumentazioa entregatu behar duzue, gutxieneko zerrendaketa bat luzatuko zaizue.
