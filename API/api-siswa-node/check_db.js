const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "db_sekolah",
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database Connection Error:", err);
    process.exit(1);
  }
  
  const tables = ['siswa', 'guru', 'jenis_catatan'];
  
  tables.forEach(table => {
    db.query(`DESCRIBE ${table}`, (err, results) => {
      if (err) {
        console.error(`❌ Table '${table}' does NOT exist or error:`, err.message);
      } else {
        console.log(`✅ Table '${table}' exists.`);
      }
      
      if (table === tables[tables.length - 1]) {
        setTimeout(() => db.end(), 1000);
      }
    });
  });
});
