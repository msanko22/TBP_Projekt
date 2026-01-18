# TBP_Projekt
Aplikacija za upravljanje korisničkim računima (vrste korisnika, prava pristupa, meta podaci) - Poopćene/Objektno-relacijske baze podataka - PostgreSQL + web grafičko sučelje po želji
**Preduvjeti za pokretanje aplikacije:** instaliran Node.js (verzija 16 +), PostgreSQL (instalacijska skripta za kreiranje baze podataka je na verziji 17, tako da je potrebno unutar batch skripte u putanji "C:\Program Files\PostgreSQL\17\bin\psql.exe" promijenit broj 17 u vašu verziju PostgreSQL-a ukoliko je različita) te je potrebno postaviti (ukoliko nije) put do PostgreSQL bin mape mora biti dodan u sistemski Path (npr. C:\Program Files\PostgreSQL\17\bin). (Postavljanje sistemskig Path-a: Search -> Edit the system environment variables -> Environmental Variables -> selektirati Path -> Edit -> New -> npr. staviti putanju do PostgreSQL bin direktorija na všem računalu (npr. C:\Program Files\PostgreSQL\17\bin\psql.exe) -> OK -> OK

### Pokretanje aplikcije
Skinite Zip datoteku sa gitbuha https://github.com/msanko22/TBP_Projekt 
Raspakirajte Zip datoteku
Uđite u direktorij Aplikacija i pokrenite instalacijsku skriptu: instaliraj_bazu.bat
Pokrenite terminal i pomaknite se unutar direktorija zatim upišite: npm install
Nakon instalacije potrebnih datoteka, pokrenite server naredbom: node index.js
Aplikacija će zatim biti dostupna na adresi: http://localhost:3000

Kao testne podatke možete koristiti: 
Za ulogu Administratora: super.admin@sustav.com
Za ulogu korisnika: pero@gmail.com

**Službeni kod projekta nalazi se na poveznici:**
https://github.com/msanko22/TBP_Projekt
