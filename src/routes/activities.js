const express = require('express');
const pool = require('../db');

const router = express.Router();

const SELECT_ACTIVITY = `
  SELECT a.id, a.title, a.description, a.location,
         a.activity_date, a.start_time, a.end_time, a.status,
         a.category_id, c.name AS category_name,
         a.neighborhood_id, n.rt, n.rw, n.hamlet_name,
         a.created_at
  FROM activities a
  JOIN activity_categories c ON c.id = a.category_id
  JOIN neighborhoods n       ON n.id = a.neighborhood_id
`;

// Mengubah error database menjadi response yang ramah
function handleError(res, err) {
  console.error(err);
  if (err.code === '23503') {
    return res.status(400).json({ success: false, message: 'category_id atau neighborhood_id tidak ditemukan' });
  }
  if (err.code === '23514' || err.code === '22007' || err.code === '22008') {
    return res.status(400).json({ success: false, message: 'Data tidak valid (cek format tanggal/jam/status)' });
  }
  return res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server' });
}

function isValidId(id) {
  return /^\d+$/.test(id);
}

// GET semua data
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`${SELECT_ACTIVITY} ORDER BY a.activity_date, a.start_time`);
    res.json({ success: true, count: result.rowCount, data: result.rows });
  } catch (err) {
    handleError(res, err);
  }
});

// GET berdasarkan ID
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  if (!isValidId(id)) {
    return res.status(400).json({ success: false, message: 'ID harus berupa angka' });
  }
  try {
    const result = await pool.query(`${SELECT_ACTIVITY} WHERE a.id = $1`, [id]);
    if (result.rowCount === 0) {
      return res.status(404).json({ success: false, message: 'Kegiatan tidak ditemukan' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

// POST buat data baru
router.post('/', async (req, res) => {
  const { category_id, neighborhood_id, title, description, location, activity_date, start_time, end_time, status } = req.body;

  if (!category_id || !neighborhood_id || !title || !activity_date) {
    return res.status(400).json({
      success: false,
      message: 'category_id, neighborhood_id, title, dan activity_date wajib diisi',
    });
  }

  try {
    const result = await pool.query(
      `INSERT INTO activities
         (category_id, neighborhood_id, title, description, location, activity_date, start_time, end_time, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, COALESCE($9, 'terjadwal'))
       RETURNING *`,
      [category_id, neighborhood_id, title, description, location, activity_date, start_time, end_time, status]
    );
    res.status(201).json({ success: true, message: 'Kegiatan berhasil dibuat', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

// PUT perbarui data
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  if (!isValidId(id)) {
    return res.status(400).json({ success: false, message: 'ID harus berupa angka' });
  }

  const { category_id, neighborhood_id, title, description, location, activity_date, start_time, end_time, status } = req.body;

  if (!category_id || !neighborhood_id || !title || !activity_date) {
    return res.status(400).json({
      success: false,
      message: 'category_id, neighborhood_id, title, dan activity_date wajib diisi',
    });
  }

  try {
    const result = await pool.query(
      `UPDATE activities
          SET category_id = $1, neighborhood_id = $2, title = $3, description = $4,
              location = $5, activity_date = $6, start_time = $7, end_time = $8,
              status = COALESCE($9, status)
        WHERE id = $10
        RETURNING *`,
      [category_id, neighborhood_id, title, description, location, activity_date, start_time, end_time, status, id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ success: false, message: 'Kegiatan tidak ditemukan' });
    }
    res.json({ success: true, message: 'Kegiatan berhasil diperbarui', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

// DELETE hapus data
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  if (!isValidId(id)) {
    return res.status(400).json({ success: false, message: 'ID harus berupa angka' });
  }
  try {
    const result = await pool.query('DELETE FROM activities WHERE id = $1 RETURNING *', [id]);
    if (result.rowCount === 0) {
      return res.status(404).json({ success: false, message: 'Kegiatan tidak ditemukan' });
    }
    res.json({ success: true, message: 'Kegiatan berhasil dihapus', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

module.exports = router;
