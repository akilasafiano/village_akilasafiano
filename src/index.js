require('dotenv').config();
const express = require('express');
const activitiesRouter = require('./routes/activities');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'API Sistem Informasi Penjadwalan Kegiatan Desa berjalan' });
});

app.use('/api/activities', activitiesRouter);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route tidak ditemukan' });
});

app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
