const mysql = require("mysql2");
const fs = require("fs");
const path = require("path");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  multipleStatements: true // Crucial for running multiple SQL commands
});

const sql = fs.readFileSync(path.join(__dirname, "../../create_db.sql"), "utf8");

db.connect((err) => {
  if (err) {
    console.error("❌ Connection failed:", err);
    process.exit(1);
  }
  
  console.log("✅ Connected to MySQL. Applying schema...");
  
  db.query(sql, (err, results) => {
    if (err) {
      console.error("❌ Error applying schema:", err);
    } else {
      console.log("✅ Schema applied successfully!");
    }
    db.end();
  });
});
