SET client_encoding = 'UTF-8';

DROP VIEW IF EXISTS v_pregled_clanova CASCADE;
DROP TABLE IF EXISTS Administrator CASCADE;
DROP TABLE IF EXISTS Korisnik CASCADE;
DROP TABLE IF EXISTS sustav_logovi CASCADE;
DROP TYPE IF EXISTS lokacija_objekt CASCADE;

CREATE TYPE lokacija_objekt AS (
    ulica TEXT,
    grad TEXT
);

CREATE TABLE Korisnik (
    id SERIAL PRIMARY KEY,
    ime_prezime TEXT NOT NULL,
    email TEXT UNIQUE,
    prebivaliste lokacija_objekt,
    dodatni_info JSONB,
    datum_registracije TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Administrator (
    razina_pristupa INT DEFAULT 10
) INHERITS (Korisnik);

CREATE VIEW v_pregled_clanova AS 
SELECT id, ime_prezime, email, (prebivaliste).grad AS grad FROM Korisnik;

CREATE TABLE sustav_logovi (
    id SERIAL PRIMARY KEY, 
    poruka TEXT, 
    stvoreno TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION funkcija_log_korisnik() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO sustav_logovi(poruka, stvoreno) 
    VALUES ('Registracija: ' || NEW.email || ' u tablicu ' || TG_TABLE_NAME, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_nakon_unosa_korisnik AFTER INSERT ON Korisnik FOR EACH ROW EXECUTE FUNCTION funkcija_log_korisnik();
CREATE TRIGGER trg_nakon_unosa_admin AFTER INSERT ON Administrator FOR EACH ROW EXECUTE FUNCTION funkcija_log_korisnik();

INSERT INTO Korisnik (id, ime_prezime, email, prebivaliste, dodatni_info) VALUES 
(1, 'Luka Šulentić', 'lsulentic@gmail.com', ROW('Ulica Kraljeva 10', 'Zadar'), '{"tema": "dark"}'),
(3, 'Leonard Inkret', 'leot@yahoo.com', ROW('Ostrvica 5', 'Gospić'), '{"jezik": "HR"}'),
(4, 'Ivana Hranj', 'ivanah@gmail.com', ROW('Trg Slobode 5', 'Sisak'), '{"tip": "obicni"}'),
(7, 'Matej Šanko', 'msanko@foi.hr', ROW('', 'Varaždin'), '{"tip": "obicni"}'),
(9, 'Pero Perić', 'pero@gmail.com', ROW('', 'Zagreb'), '{"tip": "obicni"}'),
(11, 'Marko Markić', 'markic@gmail.com', ROW('', 'Križevci'), '{"tip": "obicni"}');

INSERT INTO Administrator (id, ime_prezime, email, prebivaliste, dodatni_info, razina_pristupa) VALUES 
(5, 'Nikola Tesla', 'super.admin@sustav.com', ROW('Smiljan 1', 'Gospić'), '{"mod": "all", "sigurnost": "high"}', 10),
(6, 'Iva Operaterić', 'ivao@sustav.com', ROW('Osječka 22', 'Rijeka'), '{"mod": "read-only"}', 5),
(8, 'Ivan Ivić', 'iivan@sustav.com', ROW('', 'Petrinja'), '{"tip": "admin", "ovlasti": "full"}', 10);

SELECT setval('korisnik_id_seq', (SELECT MAX(id) FROM Korisnik));