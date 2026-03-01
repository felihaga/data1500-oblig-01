# Besvarelse - Refleksjon og Analyse

**Student:** Felix Haga

**Studentnummer:** studenNr: fehag7267

**Dato:** 01/03/26

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

jeg valgte fire Entiteter som jeg lagde ved hjelp av mermaid live.
bySykkelSystem
kunde{
SERIAL kunde_id pk
VARCHAR(50) fornavn
VARCHAR(50) etternavn
varchar(255) epost UNIQUE
VARCHAR(11) telefonnummer UNIQUE
VARCHAR(100) betalingsinfo
}
stasjon{
SERIAL stasjon_id pk
varchar(30) navn
INTEGER antall_låser
}
sykkel{
VARCHAR(20) sykkel_id pk
timestamp oprettet
}
utleie{
SERIAL utleie_id pk
SERIAL kunde_id 
VARCHAR(20) sykkel_id 
int utlevert_stasjon 
int innlevert_stasjon 
timestamp utlevert
timestamp innlevert 
numeric(12,2) leiebeløp
}

### Oppgave 1.2: Datatyper og `CHECK`-constraints

varchar valgt til attributtene til kunde. telefonnummer er det nødvendig for få med telefonnumre fra andre land hvis det skal være nødvendig. 
betalingsinformasjon var jeg usikker på, men fant ut at det er mest gunstig for valg av type.

varchar(255) epost - kan ikke starte på @
fornavn og etternavn kan ikke være null
timestamp utlevert kan ikke være null
id og navn kan ikke være null
Epost skal ha riktig ende og kan ikke starte på @
telefonnummer skal begynne på '+' og skal ha riktig lengde

mermaid kode lagt til i forrige oppgave

### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

kunde_id og sykkel_id skal ha primærnøkkel, hver sykkel og kunde skal ha en unik id.
stasjon_id skal ha pk - dette av samme grunn, det gjør at vi kan vite nøyaktig hvor hver sykkel er parkert.
utleie_id er spesifikt for hver utleie og skal derfor ha pk.


**Naturlige vs. surrogatnøkler:**

kunde_id setter jeg som surrogat siden telefonnummer og epost kan endres
sykkel_id er naturlig, den skal aldri endres så derfor gir det mening at den er naturlig.
utleie_id er surrogat siden det er ikke en naturlig kobling
stasjon_id er surrgat fordi navn kan eventuelt endres i fremtiden

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**

sykkel er en-til-mange til utleie, en sykkel kan bli leid ut flere ganger.
utleie til sykkel er det mange-til-en, det kan være flere utleier til en sykkel over tid.
stasjon til utleie er en-til-mange, det kan leies ut i flertall fra en stasjon.
fra utleie til stasjon er det mange-til-en, utleie startes og fra en stasjon. Det avsluttes også til en stasjon.

**Fremmednøkler:**

jeg vil ha en fk i utleie.kunde_id fra kunde_id
en fk i utleie.sykkel_id fra sykkel_id
og en fra utlevert og innlevert stasjon_id i utleie fra stasjon_id

### Oppgave 1.5: Normalisering



**Vurdering av 1. normalform (1NF):**

Modellen oppfyller først normal siden hver tabell har atomære verdier. Hvert felt i tabellene inneholder kun en verdi.

**Vurdering av 2. normalform (2NF):**

For at en tabell skal oppfylle 2NF må den tilfredstille 1NF og ikke ha partielle avhengigheter. Alle kolonner er avhengig av hele primærnøkkel i id i sykkel, kunde og stasjon.

**Vurdering av 3. normalform (3NF):**

En tabell oppfyller 3NF hvis den er på 2NF og ikke har noen transitive avhengigheter. Altså at ikke-nøkkel attributter ikke er avhengig av andre ikke nøkkel attributter, modellen har ikke det.

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

skriptet ligger i `init-scripts/01-init-database.sql`

**Antall testdata:**

- Kunder: 5
- Sykler: 100
- Sykkelstasjoner: 5
- Låser: 100 - 20 per stasjon
- Utleier: 50

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

data1500-postgres  | /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/01-init-database.sql
data1500-postgres  | DROP TABLE
data1500-postgres  | psql:/docker-entrypoint-initdb.d/01-init-database.sql:8: NOTICE:  table "utleie" does not exist, skipping
data1500-postgres  | psql:/docker-entrypoint-initdb.d/01-init-database.sql:9: NOTICE:  table "kunde" does not exist, skipping
data1500-postgres  | DROP TABLE
data1500-postgres  | psql:/docker-entrypoint-initdb.d/01-init-database.sql:10: NOTICE:  table "sykkel" does not exist, skipping
data1500-postgres  | DROP TABLE
data1500-postgres  | psql:/docker-entrypoint-initdb.d/01-init-database.sql:11: NOTICE:  table "stasjon" does not exist, skipping
data1500-postgres  | DROP TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | CREATE TABLE
data1500-postgres  | INSERT 0 5
data1500-postgres  | INSERT 0 5
data1500-postgres  | INSERT 0 100
data1500-postgres  | INSERT 0 50
data1500-postgres  |          status         
data1500-postgres  | ------------------------
data1500-postgres  |  Database initialisert!
data1500-postgres  | (1 row)

**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**


4 rows retrieved starting from 1 in 647 ms - er output i 'terminalen'. I table_name ble det laget 4 tabeller:1.kunde 2.stasjon 3.sykkel 4.utleie.

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

CREATE ROLE kunde;

**SQL for å opprette bruker:**

CREATE USER kunde_1 WITH PASSWORD 'passordmedbolle';
GRANT kunde TO kunde_1;

**SQL for å tildele rettigheter:**

GRANT SELECT ON stasjon, sykkel, utleie TO kunde;
GRANT SELECT (kunde_id, fornavn, etternavn, epost) ON kunde TO kunde;

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

sql

CREATE VIEW mine_utleier AS
SELECT *
FROM utleie
WHERE kunde_id = (
SELECT kunde_id
FROM kunde
WHERE epost = CURRENT_USER
);


**Ulempe med VIEW vs. POLICIES:**


POLICIES sørger for direkte sikkerhet for hver rad, mens VIEW er det ikke det og derfor kan bli et sikkerhetsproblem.

---

## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

i høysesongen: mai til september er 5 måneder, 5 * 20 000 = 100 000 utleier.
i mellomsesongen: 4 måneder med 5000 utleier, 4 * 5000 = 20 000 utleier.
i lavsesongen: desember til februar er 3 måneder med 500 utleier, 3 * 500 = 1500.
100 000 + 20 000 + 1500 = 121 500 utleier.

**Estimat for lagringskapasitet:**

SELECT AVG(pg_column_size(t.*)) AS data_bytes FROM utleie AS t; jeg brukte denne kommandoen for å første finne ut hvor mange bytes det er gjennomsnittlig i hver tabell.
kunde = 77 byte
stasjon = 45 byte
sykkel = 48 byte 
utleie = 65 byte

ved hjelp av kommandoen: SELECT COUNT(*) FROM stasjon; - så kan jeg finne ut hvor mange rader kunde, stasjon, sykkel og utleie har. 
stasjon = 5
sykkel = 100
utleie = 121 500
kunde = med 121 500 utleier på et år vil jeg sagt det kan være rundt 6000 kunder - det legger opp til rundt 20 bruk per kunde i gjennomsnitt på ett år. 

da kan jeg finne:
kunde = 77 * 6000 = 462000 byte
sykkel = 48 * 100 = 4800 byte
stasjon = 45 * 5 = 225 byte
utleie = 65 * 121500 = 7897500 byte 

**Totalt for første år:**
462000 + 4800 + 225 + 7897500 = 8364525 byte
8364525 byte = ca 8mb.


### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

Csv filen lagrer kunde-informasjon fra samme utleier utleier flere ganger som f.eks. fra Ole Hansen og Kari Olsen. Dette fyller unødvendig minne med samme informasjon.

**Problem 2: Inkonsistens**

Hvis en fil er fylt med redundans som ikke er synkronisert, vil det si at kunde informasjon vil være ulikt oppdatert og kan bli hentet feil. Det kan oppstå scenario hvor en kunde vil ha to forskjellige telefonnummer.

**Problem 3: Oppdateringsanomalier**

Litt svart i problem 2, ved redundans oppstår det flere rader med samme informasjon. Hvis en kunde vil endre, slette eller sette inn ny informasjon vil ikke alle radene blir oppdatert.
Eksempel: Hvis Ole Hanser bytter mail eller telefonnummer, må det gjøres manuelt i alle de tre radene han er i.

**Fordeler med en indeks:**

Indeks søker mer direkte og fungerer likt som crl f. Indeks leter ikke gjennom hele filen, men istedet vil starte der for eksempel riktig kunde_id starter. Kunde_id fungerer som en søkenøkkel for indeksen. 
Eksempel på dette: Hvis man vil finne alle utleier av sykkelen 'EcoBike' som er brukt tre ganger i csv filen, så kan indeks lese der sykkelen er dokumentert. Dette går raskere enn å lese hele filen.

**Case 1: Indeks passer i RAM**

Fordelen hvis indeks passer i minnet er at et søk går mye raskere, søket begynner i roten og trenger ikke å gjøre forespørsler til andre disker. 

**Case 2: Indeks passer ikke i RAM**

Hvis ikke hele indeksen passer i RAM, vil det været deler av indeksen i RAM og resten i disk. Det betyr at postgreSQL må hente deler fra disk, det tar lengre tid. 
Med flettesortering er det mulig å dele opp relevant informasjon i 'bolker', dermed trenger man ikke å ha all informasjonen i minnet samtidig, hvor noe kan gå i minnet og resten i disk. På denne måten kan indeksen i minnet lete raskere.

**Datastrukturer i DBMS:**

hash-indeks bruker has-funksjon (a->b) ved søk. Det betyr at hash-indeks er bra for spesifike og konkrete verdier, men det egner seg ikke for intervallsøk.  
B+-tre indeks er standard i postgreSQL. B+-tre indeks fordeler data i tre deler: rot, indre noder og bladnoder. Bladnodene inneholder nøklene til radene, hvor roten og de indre nodene fungerer mer som veivisere bladnodene. B+-tre er bedre for intervallsøk.
---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

Heap-fil

**Begrunnelse:**

**Skrive-operasjoner:**

En heap-fil er godt egnet for mange append-operasjoner, siden en heap-fil legger til nye logger på slutten, vil en heap-fil gi raskere skrive-operasjoner. På et år var det over 120 000+ utleier, som betyr at det er ofte logging. LSM-tree er mer kompleks og er designet for å organisere logging bedre. LSM-tree er bedre egnet for flere operasjoner, mens heap er bedre egnet for append-only.

**Lese-operasjoner:**

Med en LSM-tree fil vil lesing ta kortere tid, siden dataen er organisert. En heap-fil vil bruke lengre tid siden dataen er tilfeldig organisert. Jeg foreslo heap-fil med tanke på kvantiteten av logging kontra lesing og søking det er i en bysykkel-database.
---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

valideringen burde gjøres i alle tre delene: nettleser, applikasjonslaget og databasen.

**Validering i nettleseren:**

validering ved login og registrering gir rask respons tilbake til brukeren ved passord og brukernavn. Ulempen er at det er ikke trygt og er utsatt for hackere, ved å manipulere javascript.

**Validering i applikasjonslaget:**

Validering i applikasjonslaget er hoved sikkerheten før det brukeren sender når databasen. Her kan validering som alder og telefonnummer valideres i form av format. 

**Validering i databasen:**

Databasen kan bruke constraints og beskytter derfor dataintegritet. Det gjør også at det er enklere og implementere grunnleggende regler. Ulempen er at man ofte får vanskelige tilbakemeldinger å tolke for brukeren.

**Konklusjon:**

Valideringen burde gjøres i alle tre lagene for å sikre rask tilbakemelding til kunden og sikkerhet mot hackere.

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**

Hvordan postgreSQL kan bygges opp av filer, web og kode. Hvordan database bygges av tabeller og rader, og hvilken betydning ulike nøklar har på de. Obligen har hjulpet med å sette et mer helhetlig bilde. 

**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

Fant ikke læringsmålene.

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

Den første store utfordringen kom ved implementering av malen, mye først om hvordan implementere timestamps som gir mening. Jeg møtte på en utfordring hvor jeg måtte endre på koden og slet med ukjent error, det er der hvor drop table delen av koden min ble lagt inn. Jeg støtte på en del syntax problemer, spesielt ved implementering av testdata.

**Hva har du lært om databasedesign:**

Med obligen har jeg fått et mye større oversiktsbilde. Oblig har gjort flere ting litt mer openbart, som bare prosessen med å tegne en mal til å lage tabeller. Jeg har lært hvordan å hente informasjon og å bruke en SQL kode for å finne ut informasjon om en database som er 'brukt' (med tanke på testdata). Jeg har også lært om en kritiske feil som kan oppstå, som kan være lett å overse. Oppgave 4.2 var et godt eksempel på dette, hvordan utleier i dette tilfelle skal logges og lagres uten at feil oppstår.

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

 SQL-spørringene i `test-scripts/queries.sql`

**Slutt på besvarelse**
