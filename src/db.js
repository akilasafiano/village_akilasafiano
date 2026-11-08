require('dotenv').config();
const { Pool, types } = require('pg');

// Kembalikan tipe DATE (OID 1082) sebagai string "YYYY-MM-DD"
// agar tanggal tidak bergeser karena konversi zona waktu.
types.setTypeParser(1082, (value) => value);

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

module.exports = pool;
