class Budget {
  // 1. Properties
  final String category;
  final double limit;
  final int month;
  final int year;

  // 2. Constructor Biasa (Positional Constructor)
  Budget(this.category, this.limit, this.month, this.year);

  // 3. Named Constructor Budget.monthly
  Budget.monthly(this.category, this.limit)
      : month = DateTime.now().month, // Mengambil bulan saat ini
        year = DateTime.now().year;   // Mengambil tahun saat ini

  // Method opsional untuk menampilkan detail budget
  @override
  String toString() {
    return 'Budget ($category): Limit=${limit.toStringAsFixed(2)} for $month/$year';
  }
}

void main() {
  // Contoh Penggunaan

  // Menggunakan Constructor Biasa
  var annualBudget = Budget('Pendidikan', 5000000.0, 12, 2025);
  print('Contoh 1 (Regular): ${annualBudget.toString()}');
  
  // Menggunakan Named Constructor Budget.monthly
  var currentMonthBudget = Budget.monthly('Makanan', 1500000.0);
  print('Contoh 2 (Monthly): ${currentMonthBudget.toString()}');
  
  // Verifikasi bulan dan tahun saat ini
  var now = DateTime.now();
  print('\nVerifikasi Waktu Saat Ini: ${now.month}/${now.year}');
}
