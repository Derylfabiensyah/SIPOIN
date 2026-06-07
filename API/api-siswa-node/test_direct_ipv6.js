const { Client } = require('pg');

async function testDirect() {
  const client = new Client({
    host: '2406:da12:1f1:f800:b001:87b3:2811:4c93',
    port: 5432,
    user: 'postgres',
    password: 'sipoinapp1905',
    database: 'postgres',
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log("Connecting directly to IPv6...");
    await client.connect();
    console.log("✅ Direct IPv6 Connection Successful!");
    const res = await client.query('SELECT NOW()');
    console.log("Time:", res.rows[0]);
    await client.end();
  } catch (err) {
    console.error("❌ Direct IPv6 Connection Failed:", err);
  }
}

testDirect();
