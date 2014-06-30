-----
-- Programazio Funtzionala
-----


-----
-- S/I modulua
-----

import HuffmanKodeketa



main = do
	  putStr "Ongi etorri Huffman-en kodeketa egiten duen programara\n"
	  putStr "\n"
	  putStr "Sartu kodetu nahi duzun fitxategiaren izena (luzapen eta guzti!)\n"
	  izena <- getLine
          kodetzekoa <- readFile (izena)
	  let (zuhaitza,kodea) = kodetu kodetzekoa
	  a <- writeFile ('K':izena) kodea
	  putStr "\n"
	  putStr ("Kodeketa jadanik eginda dago. \n" ++ ('K':izena) ++ " izeneko fitxategian duzu emaitza\n" )
	  putStr "Kodetutako fitxategia deskodetzea nahi al duzu? (b,E)\n"
	  segi <- getChar
       	  if segi == 'b' || segi == 'B' then 
	           do kodetutakoa <- readFile ('K':izena)
		      b <- writeFile ('D':izena) (deskodetu (zuhaitza,kodetutakoa))
	              putStr ("\nDeskodeketa bukatu da. " ++ ('D':izena) ++ " izeneko fitxategian duzu emaitza\n")
		else
	           putStr "\nEz duzu fitxategia deskodetzerik nahi.\n"
          putStr "\nAgur !!!\n"


