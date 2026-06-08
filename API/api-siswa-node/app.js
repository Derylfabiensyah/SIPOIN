const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
const bodyParser = require("body-parser");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(bodyParser.json());

// --- KONEKSI KE SUPABASE POSTGRES ---
const db = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

db.connect((err, client, release) => {
  if (err) {
    console.error("❌ Database Tidak Terhubung!", err);
    return;
  }
  console.log("✅ Terhubung ke Supabase PostgreSQL!");
  release();
});

// --- ROUTES ---

// 1. Get All Siswa
app.get("/siswa", (req, res) => {
  console.log("📖 GET /siswa");
  db.query("SELECT * FROM siswa", (err, results) => {
    if (err) {
      console.log("❌ ERROR GET:", err);
      return res.status(500).send(err);
    }
    console.log(`✅ GET berhasil - ${results.rows.length} data`);
    res.json(results.rows);
  });
});

// TEMPORARY: Update all guru passwords to the new random neat pattern
app.get("/guru-update-all-passwords", (req, res) => {
  console.log("🔄 GET /guru-update-all-passwords");
  
  db.query("SELECT id_guru, nama, nip FROM guru", async (err, results) => {
    if (err) {
      console.log("❌ ERROR GET GURU:", err);
      return res.status(500).send(err);
    }
    
    const teachers = results.rows;
    console.log(`Found ${teachers.length} teachers. Restructuring passwords...`);
    
    const updatedList = [];
    
    try {
      for (const teacher of teachers) {
        const newPassword = generateNeatPassword();
        await db.query("UPDATE guru SET password = $1 WHERE id_guru = $2", [newPassword, teacher.id_guru]);
        updatedList.push({ id_guru: teacher.id_guru, nama: teacher.nama, nip: teacher.nip, password: newPassword });
      }
      
      console.log("✅ All guru passwords updated successfully!");
      res.json({ status: true, message: "All guru passwords updated successfully!", updated: updatedList });
    } catch (e) {
      console.log("❌ ERROR UPDATING PASSWORDS:", e);
      res.status(500).json({ status: false, error: e.message });
    }
  });
});


// Function to generate a neat password: 3-digit random prefix + 4-digit neat pattern (ABAB, AABB, A0B0, AA00)
function generateNeatPassword() {
  const prefix = Math.floor(100 + Math.random() * 900).toString();
  const patterns = [
    // ABAB
    () => {
      const a = Math.floor(Math.random() * 10);
      const b = Math.floor(Math.random() * 10);
      return `${a}${b}${a}${b}`;
    },
    // AABB
    () => {
      const a = Math.floor(Math.random() * 10);
      const b = Math.floor(Math.random() * 10);
      return `${a}${a}${b}${b}`;
    },
    // A0B0
    () => {
      const a = Math.floor(Math.random() * 10);
      const b = Math.floor(Math.random() * 10);
      return `${a}0${b}0`;
    },
    // AA00
    () => {
      const a = Math.floor(Math.random() * 9) + 1;
      return `${a}${a}00`;
    }
  ];
  const randomPattern = patterns[Math.floor(Math.random() * patterns.length)];
  return prefix + randomPattern() + '*';
}

// 2. Post Siswa (Tambah Data)
app.post("/siswa", (req, res) => {
  console.log("📝 POST /siswa");
  console.log("📦 DATA MASUK:", req.body);

  const { nama, kelas, nis, password } = req.body;
  const finalPassword = password || generateNeatPassword();
  const sql = "INSERT INTO siswa (nama, kelas, nis, password) VALUES ($1, $2, $3, $4) RETURNING id";

  db.query(sql, [nama, kelas, nis, finalPassword], (err, result) => {
    if (err) {
      console.log("❌ ERROR INSERT:", err);
      return res.status(500).send(err);
    }

    const insertId = result.rows[0].id;
    console.log("✅ BERHASIL INSERT - ID:", insertId);
    res.json({ message: "Data masuk!", id: insertId });
  });
});

// 3. Update Siswa (PUT ROUTE)
app.put("/siswa/:id", (req, res) => {
  console.log("✏️ UPDATE DATA ID:", req.params.id);
  console.log("📦 DATA:", req.body);

  const { id } = req.params;
  const { nama, kelas, nis, password } = req.body;

  if (!nama || !kelas || !nis) {
    return res.status(400).json({ message: "Field kosong!" });
  }

  let sql;
  let params;

  if (password) {
    sql = "UPDATE siswa SET nama = $1, kelas = $2, nis = $3, password = $4 WHERE id = $5";
    params = [nama, kelas, nis, password, id];
  } else {
    sql = "UPDATE siswa SET nama = $1, kelas = $2, nis = $3 WHERE id = $4";
    params = [nama, kelas, nis, id];
  }

  db.query(sql, params, (err, result) => {
    if (err) {
      console.log("❌ ERROR:", err);
      return res.status(500).send(err);
    }

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Data tidak ditemukan!" });
    }

    console.log("✅ UPDATE BERHASIL ID:", id);
    res.json({ message: "Data diupdate!", id, nama, kelas, nis });
  });
});

// 4. Delete Siswa
app.delete("/siswa/:id", (req, res) => {
  console.log("🗑️ DELETE /siswa/:id");
  const { id } = req.params;

  db.query("SELECT id_siswa FROM siswa WHERE id = $1", [id], (err, result) => {
    if (err) {
      console.log("❌ ERROR GET ID_SISWA:", err);
      return res.status(500).send(err);
    }
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Data tidak ditemukan!" });
    }
    
    const idSiswa = result.rows[0].id_siswa;
    
    db.query("DELETE FROM catatan_siswa WHERE id_siswa = $1", [idSiswa], (err) => {
      if (err) {
        console.log("❌ ERROR DELETE CATATAN:", err);
        return res.status(500).send(err);
      }
      
      db.query("DELETE FROM siswa WHERE id = $1", [id], (err) => {
        if (err) {
          console.log("❌ ERROR DELETE SISWA:", err);
          return res.status(500).send(err);
        }
        console.log("✅ BERHASIL DELETE ID:", id);
        res.json({ message: "Data dihapus!" }); 
      });
    });
  });
});

// Get Jenis Catatan Berdasarkan Tipe
app.get("/jenis_catatan/:tipe", (req, res) => {
  const { tipe } = req.params;

  const sql = "SELECT * FROM jenis_catatan WHERE tipe = $1";
  db.query(sql, [tipe], (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results.rows);
  });
});

// Post Jenis Catatan (Tambah Data)
app.post("/jenis_catatan", (req, res) => {
  console.log("📝 POST /jenis_catatan");
  const { nama, deskripsi, tipe, poin } = req.body;
  
  if (!nama || !tipe || poin === undefined) {
    return res.status(400).json({ status: false, message: "Field kosong!" });
  }

  const sql = "INSERT INTO jenis_catatan (nama, deskripsi, tipe, poin) VALUES ($1, $2, $3, $4) RETURNING id_jenis";
  db.query(sql, [nama, deskripsi || "", tipe, poin], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ status: true, message: "Data masuk!", id: result.rows[0].id_jenis });
  });
});

// Put Jenis Catatan (Update Data)
app.put("/jenis_catatan/:id", (req, res) => {
  console.log("📝 PUT /jenis_catatan/:id");
  const { id } = req.params;
  const { nama, deskripsi, poin } = req.body;

  if (!nama || poin === undefined) {
    return res.status(400).json({ status: false, message: "Field kosong!" });
  }

  const sql = "UPDATE jenis_catatan SET nama = $1, deskripsi = $2, poin = $3 WHERE id_jenis = $4";
  db.query(sql, [nama, deskripsi || "", poin, id], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ status: true, message: "Data diupdate!" });
  });
});

// Delete Jenis Catatan (Hapus Data)
app.delete("/jenis_catatan/:id", (req, res) => {
  console.log("📝 DELETE /jenis_catatan/:id");
  const { id } = req.params;

  const sql = "DELETE FROM jenis_catatan WHERE id_jenis = $1";
  db.query(sql, [id], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ status: true, message: "Data dihapus!" });
  });
});

// 6. Get Recent Activity with JOIN
app.get("/catatan_recent", (req, res) => {
  console.log("📖 GET /catatan_recent");
  const { id_guru } = req.query;
  console.log("🔍 FILTER GURU ID:", id_guru);
  
  let sql = `
    SELECT cs.*, s.nama as nama_siswa, jc.nama as nama_catatan, jc.tipe, jc.poin 
    FROM catatan_siswa cs
    JOIN siswa s ON cs.id_siswa = s.id_siswa
    JOIN jenis_catatan jc ON cs.id_jenis = jc.id_jenis
  `;

  const queryParams = [];
  if (id_guru) {
    sql += " WHERE cs.id_guru = $1 ";
    queryParams.push(id_guru);
  }

  sql += " ORDER BY cs.tanggal DESC LIMIT 10"; 
  console.log("SQL:", sql);
  console.log("Params:", queryParams);

  db.query(sql, queryParams, (err, results) => {
    if (err) {
      console.log("❌ ERROR JOIN:", err);
      return res.status(500).send(err);
    }
    res.json(results.rows);
  });
});

// 7. Get Total Poin Siswa (Summary)
app.get("/poin_siswa/:id_siswa", (req, res) => {
  const { id_siswa } = req.params;
  console.log("📊 GET /poin_siswa/" + id_siswa);

  const sql = `
    SELECT jc.tipe, COALESCE(SUM(jc.poin), 0) as total_poin
    FROM catatan_siswa cs
    JOIN jenis_catatan jc ON cs.id_jenis = jc.id_jenis
    WHERE cs.id_siswa = $1
    GROUP BY jc.tipe
  `;

  db.query(sql, [id_siswa], (err, results) => {
    if (err) {
      console.log("❌ ERROR GET POIN:", err);
      return res.status(500).send(err);
    }

    let pelanggaran = 0;
    let prestasi = 0;
    for (const row of results.rows) {
      if (row.tipe === "pelanggaran") pelanggaran = Number(row.total_poin);
      if (row.tipe === "prestasi") prestasi = Number(row.total_poin);
    }

    console.log(`✅ Poin siswa ${id_siswa}: Pelanggaran=${pelanggaran}, Prestasi=${prestasi}`);
    res.json({ pelanggaran, prestasi });
  });
});

// 8. Get Detail Poin Siswa per Tipe
app.get("/poin_siswa_detail/:id_siswa/:tipe", (req, res) => {
  const { id_siswa, tipe } = req.params;
  console.log(`📋 GET /poin_siswa_detail/${id_siswa}/${tipe}`);

  const sql = `
    SELECT cs.id_catatan, jc.nama as nama_catatan, jc.poin, g.nama as nama_guru, cs.tanggal
    FROM catatan_siswa cs
    JOIN jenis_catatan jc ON cs.id_jenis = jc.id_jenis
    JOIN guru g ON cs.id_guru = g.id_guru
    WHERE cs.id_siswa = $1 AND jc.tipe = $2
    ORDER BY cs.tanggal DESC
  `;

  db.query(sql, [id_siswa, tipe], (err, results) => {
    if (err) {
      console.log("❌ ERROR GET DETAIL POIN:", err);
      return res.status(500).send(err);
    }

    console.log(`✅ Detail poin ${tipe} siswa ${id_siswa}: ${results.rows.length} data`);
    res.json(results.rows);
  });
});

// 9. Post Catatan Siswa (Input Poin oleh Guru)
app.post("/catatan_siswa", (req, res) => {
  console.log("📝 POST /catatan_siswa");
  console.log("📦 DATA:", req.body);

  const { id_siswa, id_jenis, id_guru } = req.body;

  if (!id_siswa || !id_jenis || !id_guru) {
    return res.status(400).json({ status: false, message: "Field tidak lengkap!" });
  }

  const sql = "INSERT INTO catatan_siswa (id_siswa, id_jenis, id_guru, tanggal) VALUES ($1, $2, $3, CURRENT_DATE) RETURNING id_catatan";
  db.query(sql, [id_siswa, id_jenis, id_guru], (err, result) => {
    if (err) {
      console.log("❌ ERROR INSERT CATATAN:", err);
      return res.status(500).send(err);
    }

    const insertId = result.rows[0].id_catatan;
    console.log("✅ BERHASIL INSERT CATATAN - ID:", insertId);
    res.json({ status: true, message: "Catatan berhasil disimpan!", id_catatan: insertId });
  });
});

// 5. Login Guru & Siswa
app.post("/login", (req, res) => {
  console.log("🔐 POST /login");
  console.log("📦 Body:", req.body);
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ status: false, message: "Kolom kosong!" });
  }

  // Cek ke dalam tabel guru (username = nip, password = password)
  const sqlGuru = "SELECT * FROM guru WHERE nip = $1 AND password = $2";
  db.query(sqlGuru, [username, password], (err, resultsGuru) => {
    if (err) {
      console.log("❌ LOGIN ERROR (GURU):", err);
      return res.status(500).json({ status: false, message: "Terjadi kesalahan server" });
    }

    if (resultsGuru.rows.length > 0) {
      console.log(`✅ LOGIN BERHASIL (GURU): ${resultsGuru.rows[0].nama}`);
      return res.json({ 
        status: true, 
        message: "Login Berhasil", 
        data: { 
          id: resultsGuru.rows[0].id_guru, 
          nama: resultsGuru.rows[0].nama, 
          role: "guru",
          nip: resultsGuru.rows[0].nip
        } 
      });
    } else {
      // Jika guru tidak ditemukan, cek ke dalam tabel siswa (username = nis, password = password)
      const sqlSiswa = "SELECT * FROM siswa WHERE nis = $1 AND password = $2";
      db.query(sqlSiswa, [username, password], (err, resultsSiswa) => {
        if (err) {
          console.log("❌ LOGIN ERROR (SISWA):", err);
          return res.status(500).json({ status: false, message: "Terjadi kesalahan server" });
        }

        if (resultsSiswa.rows.length > 0) {
          console.log(`✅ LOGIN BERHASIL (SISWA): ${resultsSiswa.rows[0].nama}`);
          return res.json({ 
            status: true, 
            message: "Login Berhasil", 
            data: { 
              id: resultsSiswa.rows[0].id, 
              nama: resultsSiswa.rows[0].nama, 
              role: "siswa",
              nis: resultsSiswa.rows[0].nis
            } 
          });
        } else {
          console.log("❌ LOGIN GAGAL: Akun tidak ditemukan");
          return res.status(401).json({ status: false, message: "NIP/NIS atau Password salah!" });
        }
      });
    }
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Server jalan di port ${PORT}`);
  console.log(`📌 Base URL: http://localhost:${PORT}`);
  console.log("✅ Siap menerima request\n");
});

module.exports = app;
