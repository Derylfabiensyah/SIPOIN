const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "db_sekolah",
});

db.connect((err) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  
  db.query("DESCRIBE siswa", (err, results) => {
    console.log("SISWA SCHEMA:");
    console.log(results);
    db.query("DESCRIBE guru", (err, results) => {
        console.log("GURU SCHEMA:");
        console.log(results);
        db.end();
    });
  });
});
