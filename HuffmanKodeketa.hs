--
--  Programazio Funtzionala - 2002/2003    PRAKTIKA   Huffman kodeketa
--
module HuffmanKodeketa
(HuffmanZu,
 huffZu, 	-- ::String -> HuffmanZu
 kodetu,	-- ::String -> (HuffmanZu,Kode)
 deskodetu,	-- ::(HuffmanZu,Kode) -> String
)
where

import DmaAVL
import DmaZuBiP

---------------------------------------------------------------------------------------
-- OHARRA: txertatuRAVL funtzioaren inplementazioa DmaAVL.hs fitxategian dago	     --
--	   eta modulu horrek esportatu egin behar du funtzio hori honek funtziona    --
--	   dezan								     --
---------------------------------------------------------------------------------------



-- mergeSort ordenazio algoritmoarean inplementazioa
-- praktika guztian zehar erabiliko denez, funtzio bat 
-- du parametro gisa, zerrendako elementu bakoitzaren gakoa
-- lortzeko. Gako horren arabera egingo da ordenazioa

mergeSort :: (Ord b) => [a] -> (a -> b) -> [a]

mergeSort list gakoaLortu
  | luzera > 1  = merge (mergeSort (take erdia list) gakoaLortu) 
			(mergeSort (drop erdia list) gakoaLortu) 
			gakoaLortu
  | otherwise = list
  where
		erdia = luzera `div` 2
		luzera = length list

merge :: (Ord b) => [a] -> [a] -> (a -> b) -> [a]

merge [] list2 gakoaLortu = list2
merge list1 [] gakoaLortu = list1
merge (x:xs) (y:ys) gakoaLortu  
		| gakoaLortu x < gakoaLortu y = (x:(merge xs (y:ys) gakoaLortu))
		| gakoaLortu x == gakoaLortu y = (x:y:(merge xs ys gakoaLortu))
		| otherwise = (y:(merge (x:xs) ys) gakoaLortu)

----------------
-- 1.go fasea --
----------------

----
--Zuhaitzekin
----

type AVL = ZuAVL (Char,Int)


eginZuhaitza :: String -> AVL --ZuAVL (Char,Int) 
eginZuhaitza []  = Hutsa

--txertatuRAVL egitean (x,1) jartzen dut, baina (x,_) izango litzateke (sistemak ez du
--onartzen) bilaketa lehen elementuaren arabera egiten du "fst" funtzioari esker. Zuhaitzean 
--elementu hori (x,_) baldin badago, jadanik zuhaitzean dagoenari batu funtzioa aplikatzen 
--dio bigarren elementuaren balioa inkrementatzeko
eginZuhaitza (x:xs) = txertatuRAVL (x,1) (eginZuhaitza xs) fst batu
			where batu (x1,x2) = (x1,x2 + 1)


--lautuZuhaitza :: ZuAVL (Char,Int) -> [(Char,Int)]
lautuZuhaitza :: AVL -> [(Char,Int)]
lautuZuhaitza Hutsa = []
lautuZuhaitza (Errotu h xt y zt) = (lautuZuhaitza xt) ++ [y] ++ (lautuZuhaitza zt)	

scanTestua :: String -> [(Char,Int)]
scanTestua [] = []
scanTestua x = mergeSort ((lautuZuhaitza.eginZuhaitza) x) snd

----
--Zerrendekin
----

sortuZerrenda :: String -> [(Char,Int)]

sortuZerrenda [] = []
sortuZerrenda (x:xs) = ((x,1):sortuZerrenda xs)

ordena1 :: [(Char,Int)] -> [(Char,Int)]

ordena1 xs = mergeSort xs fst

batulehenak :: [(Char,Int)] -> [(Char,Int)]

batulehenak [] = []
batulehenak (x:[]) = [x]
batulehenak (x:(y:xs)) 
		| fst x == fst y = batulehenak ((fst x,(snd x) +1): xs)
		| otherwise = (x:batulehenak (y:xs))

scanTestua1 :: String -> [(Char,Int)]

scanTestua1 [] = []
scanTestua1 xs = mergeSort ((batulehenak.ordena1.sortuZerrenda) xs) snd



----------------
--  2. fasea  --
----------------

type HuffmanZu = ZuBiP (Char,Int) Int

hostoZerrenda :: [(Char,Int)] -> [HuffmanZu]
hostoZerrenda  = map hostoZuBiP 
-- Sarrerako zerrendako elementu guztiekin HP bat sortzen du
			

eginHuffmanZu :: [HuffmanZu] -> HuffmanZu
eginHuffmanZu (x:[]) = x
eginHuffmanZu (x:(y:xs)) = eginHuffmanZu (mergeSort ((eraikiZuBiP 
					            ((esan x) + (esan y)) x y ) : xs) esan)
		            where esan (HP z) = snd z
				  esan (EP e _ _) = e

-- esan funtzioa, zuhaitza eraikitzerakoan bere erroan jarri behar dena kalkulatzeko 
-- erabiltzen da HP edo EP izan daitekeenez, bakoitzetik kontuan hartu beharreko balioa 
-- hartzeko erabiltzen da 

huffZu :: String -> HuffmanZu
huffZu = eginHuffmanZu.hostoZerrenda.scanTestua

----------------
--  3. fasea  --
----------------


type Kode = String

lortuTaula :: HuffmanZu -> [(Char,Kode)]

lortuTaula (HP a) = [(fst a,[])]
lortuTaula (EP m xt yt) = hufmerge (lortuTaula xt) (lortuTaula yt)

hufmerge :: [(Char,Kode)] -> [(Char,Kode)] -> [(Char,Kode)]

hufmerge [] ycs = [(y,'1':cs)|(y,cs) <- ycs]
hufmerge xbs [] = [(x,'0':bs)|(x,bs) <- xbs]
hufmerge ((x,bs):xbs)((y,cs):ycs)
	| length bs <= length cs = (x,'0':bs):hufmerge xbs ((y,cs):ycs)
	| otherwise              = (y,'1':cs):hufmerge((x,bs):xbs) ycs

kodeaSortu :: [(Char,Kode)] -> Char -> Kode

kodeaSortu ((y,cs):ycs) x  
	| x == y = cs 
	| otherwise = kodeaSortu ycs x 

kodetu :: String -> (HuffmanZu,Kode)
kodetu xs = (huffZu xs,(concat (map (kodeaSortu codetable) xs)))
		where codetable = lortuTaula (huffZu xs)


deskodetu :: (HuffmanZu,Kode) -> String
deskodetu (_,[]) = []
deskodetu (zu,xs)= deskod zu xs
                        where deskod (EP a ez es) ('0':cs) = deskod ez cs
                              deskod (EP a ez es) ('1':cs) = deskod es cs
                              deskod (HP (x1,x2)) cs       = x1:deskodetu (zu,cs)

