module DmaAVL
 where
 data ZuAVL a = Hutsa | Errotu Int (ZuAVL a) a (ZuAVL a)

 instance (Show a) => Show (ZuAVL a) where
  show= erakutsi

 eginAVL [] = hutsaAVL
 eginAVL (z:zs) = txertatuAVL z (eginAVL zs)

 hutsaAVL = Hutsa


 txertatuAVL x Hutsa = eraiki Hutsa x Hutsa
 txertatuAVL x (Errotu h xt y zt) 
   | (x<y)  = batuAVL (txertatuAVL x xt) y zt
   | (x==y) = Errotu h xt y  zt
   | (x>y)  = batuAVL xt y (txertatuAVL x zt)
 
--Errepikapendun AVL zuhaitzak: balioa eta zuhaitzaz gain bi funtzio behar ditu 
--parametro gisa 1goa elementuaren gakoa lortzeko (zuhaitzean zein elementuren arabera
--kokatu behar den esateko) eta 2.a, elementua zuhaitzean baldin badago zuhaitzean
--berriz sartzean egin behar zaion eraldaketa adierazteko

 txertatuRAVL x Hutsa f1 f2 = Errotu 0 Hutsa x Hutsa
 txertatuRAVL x (Errotu h xt y zt) f1 f2
   | (f1 x)<(f1 y)  = batuAVL (txertatuRAVL x xt f1 f2) y zt
   | (f1 x)==(f1 y) = Errotu h xt (f2 y)  zt                 
   | (f1 x)>(f1 y)  = batuAVL xt y (txertatuRAVL x zt f1 f2)

 
 ezabatuAVL x Hutsa = Hutsa
 ezabatuAVL x (Errotu h xt y zt)
   | (x<y)  = batuAVL (ezabatuAVL x xt) y zt
   | (x==y) = batu xt zt
   | (x>y)  = batuAVL xt y (ezabatuAVL x zt)


 hutsaDaAVL Hutsa = True
 hutsaDaAVL (Errotu _ _ _ _) = False
 


 daAVL zs= bilaketaZuDa zs && orekatuaDa zs


 dagoAVL x Hutsa = False
 dagoAVL x  (Errotu h xt y zt)
   | (x<y)  = dagoAVL x xt
   | (x==y) = True
   | (x>y)  = dagoAVL x zt


 foldAVL f g Hutsa = g
 foldAVL f g (Errotu h  xt y zt) = f (foldAVL f g xt) 
                                      y
                                     (foldAVL f g zt)


 lautuAVL = foldAVL con katH
            where  katH      = []
                   con a b c = a ++ [b] ++ c



 ------- Eragiketa laguntzaileak
 --------------------------------
 hZu :: ZuAVL a -> Int
 hZu Hutsa = 0
 hZu (Errotu h _ _ _) = h

 eraiki :: ZuAVL a -> a -> ZuAVL a -> ZuAVL a
 eraiki xt y zt = Errotu h  xt y zt
                 where h = 1 + max (hZu xt) (hZu zt)
 
 malda :: ZuAVL a -> Int
 malda (Errotu h xt y zt) = hZu xt - hZu zt
 
 errotS :: ZuAVL a -> ZuAVL a
 errotS (Errotu m (Errotu n  ut v wt) y zt) = eraiki ut v (eraiki wt y zt)

 errotZ :: ZuAVL a -> ZuAVL a
 errotZ (Errotu m xt y (Errotu n ut s wt)) = eraiki (eraiki xt y ut) s wt
 

 batu :: (Ord a) => ZuAVL a -> ZuAVL a -> ZuAVL a
 batu xt yt 
   = if hutsaDaAVL yt then xt else batuAVL xt y zt
     where (y,zt) = banatuZu yt

 banatuZu :: (Ord a) => ZuAVL a -> (a, ZuAVL a)
 banatuZu (Errotu h xt y zt)
   = if hutsaDaAVL xt then (y,zt) else (u, batuAVL vt y zt)
     where (u,vt) = banatuZu xt
 				
 batuAVL:: (Ord a) => ZuAVL a -> a -> ZuAVL a -> ZuAVL a
 batuAVL xt y zt
   | (hz+1<hx) && (malda xt <0) = errotS (eraiki (errotZ xt) y zt)
   | (hz+1 < hx)                = errotS (eraiki xt y zt)
   | (hx+1<hz) && (0< malda zt) = errotZ (eraiki xt y (errotS zt))
   | (hx+1<hz)                  = errotZ (eraiki xt y zt)
   | otherwise                  = eraiki xt y zt
   where hx = hZu xt
         hz = hZu zt

 orekatuaDa :: ZuAVL a -> Bool
 orekatuaDa Hutsa = True
 orekatuaDa (Errotu  h xt y zt) 
  = (orekatuaDa  xt) && (orekatuaDa zt) && (-1<= malda z) && (malda z<=1)
    where  z = (Errotu  h xt y zt)

 bilaketaZuDa :: Ord a => ZuAVL a -> Bool
 bilaketaZuDa = ordenatua.lautuAVL
 		where ordenatua []=True
                      ordenatua [x]=True
                      ordenatua (x:y:ys) = (x<=y) && ordenatua (y:ys)


 erakutsi:: Show a => ZuAVL a -> String
 erakutsi = erak 0
 erak n (Hutsa) = zuriak n ++"()\n"
 erak n (Errotu  h xt y zt) = concat[erak (n+5) zt,
                                     zuriak n, (show y), ":", show h, "\n",
                                     erak (n+5) xt]

 zuriak k = [' ' |_<-[1..k]]


 
