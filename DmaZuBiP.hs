module DmaZuBiP
 (ZuBiP(),
  hostoZuBiP,
  erroaZuBiP,
  eraikiZuBiP,
  bAdabegiKop, 
  mapZuBiP, 
  foldZuBiP, 
  hostoKop,
  erpinKop, 
  garaiera, 
  lautu,
  lautuHostoak,
  lautuBarnekoak,
 ) where

 data ZuBiP a b= HP a | EP b (ZuBiP a b) (ZuBiP a b) 

-- Show-ren instantzia  
 instance (Show a,Show b) => Show (ZuBiP a b) where
   show = erakutsi


 hostoZuBiP e = HP e

 erroaZuBiP (HP x) = x
 erroaZuBiP (EP e _ _)= e

 eraikiZuBiP e zt st = EP e zt st

 bAdabegiKop (HP zh) = 0
 bAdabegiKop (EP e zz sz)
  = 1 + bAdabegiKop zz + bAdabegiKop sz

 mapZuBiP f g (HP zh) = HP (f zh) 
 mapZuBiP f g (EP e zz sz)
  = EP (g e) (mapZuBiP f g zz)(mapZuBiP f g sz) 



 foldZuBiP f g (HP zh) = f zh
 foldZuBiP f g (EP e zz sz)  = g e (foldZuBiP f g zz) (foldZuBiP f g sz)


 hostoKop = foldZuBiP (const 1) bat'
           where bat' e zn sn = zn + sn

 erpinKop = foldZuBiP (const 1) batu
           where batu e zn sn = 1+zn + sn

 garaiera = foldZuBiP (const 0) g
           where g e m n = 1+ max m n

 lautu:: ZuBiP a a -> [a]
 lautu = foldZuBiP zerrendatu kat'
         where zerrendatu m = [m]
               kat' e zk sk = [e]++zk++sk

 lautuHostoak = foldZuBiP zerrendatu kat'
                where zerrendatu m = [m]
                      kat' e zk sk = zk++sk

 lautuBarnekoak = foldZuBiP zerrendatu kat'
                  where zerrendatu m = []
                        kat' e zk sk = [e]++zk++sk

 erakutsi :: (Show a, Show b) => ZuBiP a b -> String
 erakutsi = erak 0
 erak n (HP ax) = zuriak n ++ show ax ++"\n"
 erak n (EP  e xt zt) = concat[erak (n+5) zt, 
                                   zuriak n, (show e), "\n",
                                   erak (n+5) xt]

 zuriak k = [' ' |_<-[1..k]]

