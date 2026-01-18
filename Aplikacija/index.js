const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'korisnici_projekt',
  password: 'projekt123', 
  port: 5432,
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/provjeri-korisnika', async (req, res) => {
    const { email } = req.query;
    try {
        const result = await pool.query(
            `SELECT *, (tableoid = 'administrator'::regclass) AS je_admin 
             FROM Korisnik WHERE email = $1 LIMIT 1`, 
            [email]
        );
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).json({ error: "Korisnik nije pronađen" });
        }
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/korisnici', async (req, res) => {
    const { uloga } = req.query;
    try {
        let sql = 'SELECT id, ime_prezime, email, (prebivaliste).grad AS grad, dodatni_info, (tableoid = \'administrator\'::regclass) AS je_admin FROM Korisnik';
        
        if (uloga !== 'true') {
            sql += " WHERE (tableoid != 'administrator'::regclass)";
        }
        
        const result = await pool.query(sql);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/dodaj', async (req, res) => {
  const { ime, email, grad } = req.body;
  try {
    await pool.query(
      `INSERT INTO Korisnik (ime_prezime, email, prebivaliste, dodatni_info) 
       VALUES ($1, $2, ROW('', $3), '{"tip": "obicni"}')`, 
      [ime, email, grad]
    );
    res.sendStatus(201);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.post('/dodaj-admina', async (req, res) => {
  const { ime, email, grad } = req.body;
  try {
    await pool.query(
      `INSERT INTO Administrator (ime_prezime, email, prebivaliste, razina_pristupa, dodatni_info) 
       VALUES ($1, $2, ROW('', $3), 10, '{"tip": "admin", "ovlasti": "full"}')`, 
      [ime, email, grad]
    );
    res.sendStatus(201);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.delete('/obrisi/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('DELETE FROM Korisnik WHERE id = $1', [id]);
        res.sendStatus(200);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});
app.put('/azuriraj/:id', async (req, res) => {
    const { id } = req.params;
    const { ime, email, grad } = req.body;
    try {
        await pool.query(
            `UPDATE Korisnik 
             SET ime_prezime = $1, 
                 email = $2, 
                 prebivaliste = ROW('', $3) 
             WHERE id = $4`, 
            [ime, email, grad, id]
        );
        res.sendStatus(200);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(3000, () => {
  console.log('Server pokrenut na http://localhost:3000');
});