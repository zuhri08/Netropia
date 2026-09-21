const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const vm = require('vm');

// ===============================
// FIREBASE ADMIN INITIALIZATION
// ===============================

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ===============================
// LOKASI FILE MASTER DATA
// ===============================

const dartFile = path.join(
  __dirname,
  '..',
  'lib',
  'data',
  'tkj_items.dart'
);

// ===============================
// BACA tkj_items.dart
// ===============================

if (!fs.existsSync(dartFile)) {
  console.error('❌ File tkj_items.dart tidak ditemukan!');
  console.error(dartFile);
  process.exit(1);
}

const dartContent = fs.readFileSync(dartFile, 'utf8');

// Cari bagian:
//
// const List<Map<String, dynamic>> tkjItems = [
//   ...
// ];

const startMarker = 'tkjItems =';
const startIndex = dartContent.indexOf(startMarker);

if (startIndex === -1) {
  console.error('❌ Variabel tkjItems tidak ditemukan.');
  process.exit(1);
}

const arrayStart = dartContent.indexOf('[', startIndex);
const arrayEnd = dartContent.lastIndexOf('];');

if (arrayStart === -1 || arrayEnd === -1) {
  console.error('❌ Struktur List tkjItems tidak valid.');
  process.exit(1);
}

const arrayText = dartContent.substring(
  arrayStart,
  arrayEnd + 1
);

// ===============================
// PARSE LIST DART
// ===============================
//
// Data tkj_items.dart menggunakan
// struktur Map/List yang kompatibel
// dengan JavaScript.
//

let items;

try {
  items = vm.runInNewContext(`(${arrayText})`);
} catch (error) {
  console.error('❌ Gagal membaca tkj_items.dart.');
  console.error(error.message);
  process.exit(1);
}

// ===============================
// VALIDASI
// ===============================

if (!Array.isArray(items)) {
  console.error('❌ tkjItems bukan sebuah List.');
  process.exit(1);
}

console.log('');
console.log('======================================');
console.log(' NETROPIA - SEEDER INVENTARIS TKJ');
console.log('======================================');
console.log('');
console.log(`Jumlah data ditemukan: ${items.length}`);

if (items.length !== 196) {
  console.warn('');
  console.warn(
    `⚠️ PERINGATAN: jumlah item adalah ${items.length}, bukan 196.`
  );
  console.warn(
    'Seeder tetap dihentikan agar data tidak masuk secara tidak sengaja.'
  );
  process.exit(1);
}

// ===============================
// VALIDASI ID
// ===============================

const ids = new Set();

for (const item of items) {
  if (!item.id) {
    console.error('❌ Ada item tanpa ID.');
    console.error(item);
    process.exit(1);
  }

  if (ids.has(item.id)) {
    console.error(`❌ ID duplikat ditemukan: ${item.id}`);
    process.exit(1);
  }

  ids.add(item.id);
}

console.log('✓ Semua ID valid');
console.log('✓ Tidak ada ID duplikat');
console.log('');

// ===============================
// TAMPILKAN DATA
// ===============================

console.log('Data yang akan dimasukkan:');

items.slice(0, 5).forEach((item) => {
  console.log(
    `  ${item.id} | ${item.nama} | ${item.kategori}`
  );
});

console.log('  ...');
console.log(
  `  ${items[items.length - 1].id} | ${items[items.length - 1].nama}`
);

console.log('');

// ===============================
// SEED FIRESTORE
// ===============================

async function seedItems() {
  try {
    console.log('Mulai memasukkan data ke Firestore...');
    console.log('');

    const BATCH_SIZE = 400;

    for (let i = 0; i < items.length; i += BATCH_SIZE) {
      const batch = db.batch();

      const chunk = items.slice(i, i + BATCH_SIZE);

      for (const item of chunk) {
        const itemId = item.id;

        const docRef = db
          .collection('items')
          .doc(itemId);

        batch.set(
          docRef,
          {
            id: item.id,
            nama: item.nama,
            kategori: item.kategori,
            jenis: item.jenis,
            stok: Number(item.stok) || 0,
            tersedia: Number(item.tersedia) || 0,
            kondisi: item.kondisi || 'Baik',
            status: item.status || 'tersedia',
            dapatDipinjam: item.dapatDipinjam === true,
            lokasi: item.lokasi || 'Lab TKJ',
            deskripsi: item.deskripsi || '',
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          },
          {
            merge: true,
          }
        );
      }

      await batch.commit();

      console.log(
        `✓ ${Math.min(i + chunk.length, items.length)} / ${items.length} item berhasil`
      );
    }

    console.log('');
    console.log('======================================');
    console.log(' SEEDING BERHASIL');
    console.log('======================================');
    console.log('');
    console.log(`✓ ${items.length} item masuk ke Firestore`);
    console.log('✓ Collection: items');
    console.log('');

    process.exit(0);
  } catch (error) {
    console.error('');
    console.error('❌ SEEDING GAGAL');
    console.error('');
    console.error(error);
    process.exit(1);
  }
}

seedItems();