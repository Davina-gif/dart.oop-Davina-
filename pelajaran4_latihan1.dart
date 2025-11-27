class Category {
  // 1. Private Properties: Menggunakan underscore (_) di awal
  // untuk menandakan bahwa properti ini hanya boleh diakses di dalam file ini (library private).
  String _name;
  String _icon;
  double _budget;

  // Constructor untuk inisialisasi awal
  Category(this._name, this._icon, this._budget);

  // 2. Getters untuk Semua Properti (Read Access)
  
  String get name => _name;
  String get icon => _icon;
  double get budget => _budget;

  // 3. Setter untuk _budget (Write Access dengan Validasi)
  
  // Setter hanya mengizinkan nilai positif.
  set budget(double newBudget) {
    if (newBudget >= 0) {
      _budget = newBudget;
    } else {
      // Opsi: Anda bisa melempar error, atau memberikan pesan peringatan.
      // Di sini, kita hanya mencetak peringatan.
      print('Peringatan: Budget harus bernilai positif (>= 0). Nilai tidak diubah.');
    }
  }

  // 4. Computed Getter: isOverBudget
  // Mengambil satu parameter (spent) dan membandingkannya dengan _budget.
  bool isOverBudget(double spent) {
    return spent > _budget;
  }
}

void main() {
  // Inisialisasi object
  var travelCategory = Category('Travel', '✈️', 1500000.0);
  print('--- Data Awal ---');
  print('Kategori: ${travelCategory.name}'); // Mengakses melalui getter
  print('Budget: ${travelCategory.budget}');  // Mengakses melalui getter
  
  // Contoh 1: Menggunakan Setter 
  print('\n--- Menggunakan Setter ---');
  travelCategory.budget = 2000000.0;
  print('Budget Baru: ${travelCategory.budget}');
  
  // Contoh 2: Menggunakan Setter 
  travelCategory.budget = -500000.0;
  print('Budget Setelah Percobaan Gagal: ${travelCategory.budget}'); // Nilai tetap 2000000.0
  
  // Contoh 3: Menggunakan Computed Getter (isOverBudget)
  print('\n--- Menggunakan Computed Getter ---');
  double totalSpent = 2100000.0;
  print('Pengeluaran: ${totalSpent.toStringAsFixed(2)}');
  print('Status Over Budget: ${travelCategory.isOverBudget(totalSpent)}'); // true (2,100,000 > 2,000,000)

  totalSpent = 1000000.0;
  print('Pengeluaran: ${totalSpent.toStringAsFixed(2)}');
  print('Status Over Budget: ${travelCategory.isOverBudget(totalSpent)}'); // false
}