class CategoryManager {
  // Gunakan List sesuai petunjuk, dengan inisialisasi kategori awal
  final List<String> _categories = ['Makanan', 'Transportasi', 'Tagihan']; 

  // Method untuk menambahkan kategori baru
  void addCategory(String category) {
    String normalizedCategory = category.trim();
    if (normalizedCategory.isEmpty) {
      print('❌ Nama kategori tidak boleh kosong.');
      return;
    }
    
    // Konversi semua kategori ke lowercase untuk memeriksa duplikasi
    if (_categories.map((c) => c.toLowerCase()).contains(normalizedCategory.toLowerCase())) {
      print('⚠️ Kategori "$category" sudah ada.');
      return;
    }

    // Tambahkan kategori baru ke list
    _categories.add(normalizedCategory);
    print('✅ Kategori "$normalizedCategory" ditambahkan.');
  }

  // Method untuk menghapus kategori
  bool removeCategory(String category) {
    // Hapus kategori dengan mencocokkan secara case-insensitive
    int initialLength = _categories.length;
    _categories.removeWhere((c) => c.toLowerCase() == category.toLowerCase());
    
    if (_categories.length < initialLength) {
      print('🗑️ Kategori "$category" berhasil dihapus.');
      return true;
    } else {
      print('❌ Kategori "$category" tidak ditemukan.');
      return false;
    }
  }

  // Getter yang aman: mengembalikan List yang tidak dapat diubah (read-only)
  List<String> get allCategories => List.unmodifiable(_categories);
}

// -----------------------------------------------------------------

void main() {
  var manager = CategoryManager();

  print('Kategori Awal: ${manager.allCategories}');

  // Uji Penambahan
  manager.addCategory('Hiburan');
  manager.addCategory('Makan'); // Duplikasi (case-insensitive)
  manager.addCategory('Investasi');

  print('\nKategori Setelah Tambah: ${manager.allCategories}');

  // Uji Penghapusan
  manager.removeCategory('Tagihan');
  manager.removeCategory('Tagihan'); // Hapus yang tidak ada
  
  // Uji Penghapusan dengan casing berbeda
  manager.removeCategory('transportasi'); 

  print('\nKategori Setelah Hapus: ${manager.allCategories}');
}