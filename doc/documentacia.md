#Tretie odovzdanie

Do tretieho, konečného odovzdania sa mi podarilo implementovať všetky požadované scenáre,
ktoré boli požadované pre tento projekt. 


#Scenár 1
Zobrazujem všetky záznamy nejakého typu hneď dva krát. Najprv v koreni projektu, kde zobrazujem 
všetky dostupné videá a potom na /users, kde zobrazujem zasa všetkých používateľov. 


Implementoval som filtrovanie videí pomocou tagov, pre ktoré mam samostatnú tabulku v databáze. 
V oboch prípadoch (keď zobrazujem všetky záznamy, aj filtovanú množinu) používam stránkovanie
v kombinácii s infinite scrolling. 

Ako štatistiku, ktorú ziskavam pomocou group by je počet tagov na každom videu. 

#Scenár 2

Zobrazenie konkrétneho videa je možné po kliknutí na jeho thumbnail. Po kliknutí sa zobrazí 
video so všetkými jeho atribútmi.

#Scenár 3
Pri vytváraní nového videa sa dá špecifikovať nazov, opis aj aj video samotné sa dá nahrať 
z počítača. Ďalej sa už priamo tam dajú vložiť aj tagy. 


Nový záznam sa dá vytvoriť aj pri registrovaní nového používateľa.

#Scenár 4

Aktualizácia nového záznamu ide dvoma spôsobmi. Buď sa dajú aktualizovať atribúty každého
videa alebo sa dá aplikovať jednoduchá editácia videa, ktorá je pointou tohto projektu. Nestihol 
som ale implementovať iné možnosti úpravy videa ako pridanie textu. Práve úprava videa je 
hlavnou funkcionalitou na ktorej na ktorej sa do odovzdania projektu na VOS budem ešte hrať.

#Scenár 5
Vymazanie záznamu je tiež zabezpečené. Prihlásený používateľ môže bez problémov vymazať 
video.