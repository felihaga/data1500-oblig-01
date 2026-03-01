-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller

DROP TABLE IF EXISTS utleie CASCADE;
DROP TABLE IF EXISTS kunde CASCADE;
DROP TABLE IF EXISTS sykkel CASCADE;
DROP TABLE IF EXISTS stasjon CASCADE;




CREATE TABLE kunde (
    kunde_id SERIAL PRIMARY KEY,
    telefonnummer VARCHAR(11) UNIQUE NOT NULL,
    epost VARCHAR(255) UNIQUE NOT NULL,
    fornavn VARCHAR(50) NOT NULL,
    etternavn VARCHAR(50) NOT NULL,
    kort_betaling VARCHAR(100),

    CONSTRAINT chk_gyldig_telefon CHECK (LENGTH(telefonnummer) = 11),
    CONSTRAINT chk_gyldig_epost CHECK (epost NOT LIKE '@%')
);

CREATE TABLE stasjon (
    stasjon_id SERIAL PRIMARY KEY,
    navn VARCHAR(100) UNIQUE NOT NULL,
    antall_låser INTEGER NOT NULL CHECK (antall_låser >= 10 AND antall_låser <= 30)
);

CREATE TABLE sykkel (
    sykkel_id VARCHAR(20) PRIMARY KEY,
    registrert_dato TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE utleie (
    utleie_id SERIAL PRIMARY KEY,
    kunde_id INTEGER NOT NULL REFERENCES kunde(kunde_id) ON DELETE RESTRICT,
    sykkel_id VARCHAR(20) NOT NULL REFERENCES sykkel(sykkel_id) ON DELETE RESTRICT,
    utlevert_stasjon_id INTEGER NOT NULL REFERENCES stasjon(stasjon_id) ON DELETE RESTRICT,
    utlevert_tidspunkt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    innlevert_stasjon_id INTEGER REFERENCES stasjon(stasjon_id) ON DELETE SET NULL,
    innlevert_tidspunkt TIMESTAMPTZ,
    leiebeløp NUMERIC(10,2) CHECK (leiebeløp IS NULL OR leiebeløp >= 0),

    CONSTRAINT chk_innlevering_etter_utlevering CHECK (
        innlevert_tidspunkt IS NULL OR
        innlevert_tidspunkt > utlevert_tidspunkt
    ),
    CONSTRAINT chk_utleid_sykkel_ikke_innlevert CHECK (
        innlevert_tidspunkt IS NULL OR
        innlevert_stasjon_id IS NOT NULL
    )
);

-- Sett inn testdata

INSERT INTO kunde (telefonnummer, epost, fornavn, etternavn, kort_betaling) VALUES
('+4746929293','felihaga@gmail.com','Felix','Haga','visa'),
('+4734458293','adrihaga@gmail.com','Adrian','Haga','visa'),
('+4794837383','erikarlson@gmail.com','Erik','Karlson','visa'),
('+0173848495','fredJohnson@gmail.com','Freddy','Johnson','amex'),
('+4792290433','Davdehli@gmail.com','David','Dehli','visa');


INSERT INTO Stasjon (navn, antall_låser) VALUES
('Storgata',20),
('Oslo s',20),
('Slottsplassen',20),
('Nationaltheatret',20),
('Majorstuen',20);

INSERT INTO sykkel (sykkel_id)
SELECT 'BIKE-' || LPAD(g.nr::text, 3, '0')
FROM generate_series(1, 100) g(nr);

INSERT INTO utleie (kunde_id, sykkel_id, utlevert_stasjon_id, utlevert_tidspunkt, leiebeløp)
SELECT
    floor(random() * 5 + 1)::int AS kunde_id,
    'BIKE-' || LPAD(floor(random() * 100 + 1)::int::text, 3, '0') AS sykkel_id,
    floor(random() * 5 + 1)::int AS stasjon_id,
    CURRENT_TIMESTAMP - (random() * 30 || ' days')::interval,
    round((random() * 150 + 20)::numeric, 2) AS leiebeløp
FROM generate_series(1, 50);



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;

-- oblig01.public> SELECT 'Database initialisert!' as status