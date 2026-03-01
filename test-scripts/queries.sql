-- ============================================================================
-- TEST-SKRIPT FOR OBLIG 1
-- ============================================================================

-- utført i konsoll

-- 5.1
SELECT * FROM sykkel

-- 5.2
SELECT fornavn, etternavn, telefonnummer
FROM kunde
ORDER BY etternavn ASC

-- 5.3
SELECT *
FROM sykkel
WHERE registrert_dato > '2026-02-01'

-- 5.4
SELECT COUNT(*)
FROM kunde

-- 5.5
SELECT k.kunde_id, k.etternavn, COUNT(u.utleie_id) AS antall_utleier
FROM kunde k LEFT JOIN utleie u ON k.kunde_id = u.kunde_id
GROUP BY k.kunde_id, k.etternavn
ORDER BY k.etternavn ASC

--5.6
SELECT k.kunde_id, k.fornavn, k.etternavn
FROM kunde k LEFT JOIN utleie u ON k.kunde_id = u.kunde_id
WHERE u.utleie_id IS NULL

--5.7
SELECT s.sykkel_id
FROM sykkel s LEFT JOIN utleie u ON s.sykkel_id = u.sykkel_id
WHERE u.utleie_id IS NULL

--5.8
SELECT u.sykkel_id,k.fornavn,k.etternavn,u.utlevert_tidspunkt
FROM utleie u JOIN kunde k ON u.kunde_id = k.kunde_id
WHERE u.innlevert_tidspunkt IS NULL
AND u.utlevert_tidspunkt < CURRENT_TIMESTAMP - INTERVAL '24 hours'