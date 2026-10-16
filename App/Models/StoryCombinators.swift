import Foundation

enum StoryCombinators {
  static let settings: [String] = [
    "Hutan Jamur Bercahaya",
    "Kota Awan dan Pelangi",
    "Pulau Pasir Bintang di Angkasa",
    "Bawah Laut Warna-Warni",
    "Dapur Kue Raksasa",
    "Kebun Belakang Rumah yang Jadi Hutan Rimba",
    "Perpustakaan Buku-Buku Melayang",
    "Kereta Api yang Berjalan di Atas Air",
    "Desa Mainan Hidup",
    "Lembah Gelembung Sabun",
    "Gua Kristal Bernyanyi",
    "Benteng Bantal di Kamar Tidur",
    "Pasar Buah yang Bicara",
    "Puncak Bukit Angin Sejuk",
    "Stasiun Luar Angkasa Mini"
  ]

  static let companions: [String] = [
    "Kucing Cerdik Bersepatu Roda",
    "Robot Kecil yang Pemalu",
    "Anak Dinosaurus yang Suka Makan Daun Manis",
    "Bintang Jatuh yang Kehilangan Arah",
    "Awan Putih yang Bisa Berubah Bentuk",
    "Burung Hantu Bijak Berkacamata Besar",
    "Kelinci Pelompat Cepat yang Suka Bernyanyi",
    "Lumba-Lumba Terbang",
    "Kura-Kura Penjelajah yang Santai",
    "Beruang Madu yang Pandai Memasak",
    "Pohon Tua yang Ramah dan Suka Cerita",
    "Kunang-Kunang Pembawa Lentera Terang",
    "Rubah Cilik yang Jago Bermain Teka-Teki",
    "Gajah Mini Seukuran Anak Kucing",
    "Sepeda Roda Tiga yang Bisa Menyetir Sendiri"
  ]

  static let missions: [String] = [
    "Mencari Kunci Rahasia Pintu Pelangi",
    "Mengembalikan Suara Nyanyian Burung yang Hilang",
    "Membantu Bulan yang Sedang Tersenyum Kecut",
    "Menemukan Resep Kue Bikin Tertawa",
    "Mengantar Surat Bintang yang Nyasar",
    "Memperbaiki Jembatan Biskuit yang Patah",
    "Mencari Warna Pelangi yang Sedang Bersembunyi",
    "Membangunkan Angin yang Ketiduran",
    "Menangkap Bintang Terbang yang Lepas",
    "Menemukan Topi Sahabat yang Terbawa Balon",
    "Menghibur Bunga yang Layu karena Kurang Musik",
    "Membuka Peti Rahasia Kakek Penjelajah",
    "Membantu Bayi Komet Pulang ke Rumahnya",
    "Mengumpulkan Serbuk Cahaya untuk Lentera Malam",
    "Memecahkan Teka-Teki Jam Waktu yang Berputar Mundur"
  ]

  static let magicItems: [String] = [
    "Senter Pemancar Melodi Lagu",
    "Kacamata Temukan Kebaikan",
    "Payung yang Bisa Melayang Pelan",
    "Pensil Warna yang Gambarnya Bisa Jadi Nyata",
    "Kompas Ajaib yang Menunjuk ke Arah Teman",
    "Sepatu Bot yang Bisa Melompat Setinggi Awan",
    "Botol Gelembung Pembawa Pesan",
    "Selimut Hangat yang Menghilangkan Rasa Takut",
    "Peluit Pemanggil Hewan Ramah",
    "Ransel Kecil yang Isinya Tidak Pernah Habis",
    "Jam Tangan Pengatur Cuaca Sederhana",
    "Biji Bunga Emas yang Cepat Tumbuh",
    "Cermin yang Bisa Memberi Petunjuk Bijak",
    "Buku Harian yang Tahu Jawaban Teka-Teki",
    "Pita Rambut Pembuat Tubuh Jadi Ringan"
  ]

  static let weatherMoods: [String] = [
    "Pagi Beraroma Roti Hangat",
    "Hujan Gelembung Sabun Berwarna-Warni",
    "Angin Sepoi-Sepoi yang Bersiul Merdu",
    "Malam Bertabur Bintang Kerlap-Kerlip",
    "Siang Hangat dengan Awan Mirip Kapas",
    "Gerimis Halus Beraroma Madu",
    "Kabut Pelangi yang Berkilauan",
    "Langit Sore Jingga Berhias Awan Gula-Gula",
    "Hujan Salju Lembut yang Dingin dan Bersih",
    "Hari Cerah Penuh Kicau Burung Gembira",
    "Bintang Jatuh yang Meluncur Lambat",
    "Malam Sejuk yang Bikin Enak Berselimut",
    "Senja Teduh dengan Cahaya Keemasan",
    "Angin Lembut Pembawa Wangi Bunga Semerbak",
    "Bulan Purnama yang Bersinar Ramah"
  ]

  static let kindActions: [String] = [
    "Mengajak Tertawa Bersama",
    "Berbagi Bekal Makanan Enak",
    "Mengucap Kata Ajaib: Tolong, Maaf, dan Terima Kasih",
    "Bekerja Sama Saling Bergandengan Tangan",
    "Memberi Pelukan Hangat yang Menenangkan",
    "Berani Bertanya dengan Sopan dan Lembut",
    "Mendengarkan Cerita Teman dengan Sabar",
    "Bernyanyi Bersama dengan Irama Ceria",
    "Menari Gembira Berputar Tiga Kali",
    "Menggambar Petunjuk dengan Pensil Bersama",
    "Tersenyum Ramah Tanpa Rasa Takut",
    "Membagi Tugas secara Adil dan Kompak",
    "Membereskan Mainan Bersama-sama",
    "Memaafkan Teman yang Tidak Sengaja Salah",
    "Meniup Napas Hangat Penuh Kasih Sayang"
  ]

  static func randomRoll() -> SelectedStoryFactors {
    SelectedStoryFactors(
      setting: settings.randomElement() ?? settings[0],
      companion: companions.randomElement() ?? companions[0],
      mission: missions.randomElement() ?? missions[0],
      magicItem: magicItems.randomElement() ?? magicItems[0],
      weatherMood: weatherMoods.randomElement() ?? weatherMoods[0],
      kindAction: kindActions.randomElement() ?? kindActions[0]
    )
  }
}
