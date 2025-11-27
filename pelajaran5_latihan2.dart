class Expense {
  // Private Property
  final String description;
  final String category;
  final double _amount; // Private property untuk menyimpan jumlah asli

  // Constructor
  Expense({
    required this.description,
    required this.category,
    required double amount,
  }) : _amount = amount; // Inisialisasi properti private

  // Getter (Optional, untuk mengakses _amount jika diperlukan)
  double get amount => _amount;

  // Method Tambahan
  
  // 1. getAmountRounded()
  double getAmountRounded() {
    // Mengembalikan jumlah yang dibulatkan ke bilangan bulat terdekat
    return _amount.roundToDouble();
  }

  // 2. getDailyAverage(int days)
  double getDailyAverage(int days) {
    if (days <= 0) {
      // Mencegah pembagian dengan nol atau angka negatif
      return 0.0;
    }
    return _amount / days;
  }

  // 3. projectedYearly()
  double projectedYearly() {
    // Proyeksi tahunan = jumlah bulanan * 12
    return _amount * 12;
  }
  
  // Method Tambahan untuk menggantikan getFormattedAmount()
  String getFormattedAmount() {
    return 'Rp ${_amount.toStringAsFixed(2)}';
  }
}

void main() {
  // Inisialisasi dengan data
  var subscription = Expense(
    description: 'Netflix',
    category: 'Hiburan',
    amount: 15.99, // Contoh jumlah yang tidak bulat
  );

  print('--- Hasil Perhitungan ---');
  // Perbaikan: Menggunakan getFormattedAmount() yang baru ditambahkan
  print('Jumlah: ${subscription.getFormattedAmount()}'); 
  
  // Menggunakan method yang diminta
  print('Dibulatkan: Rp${subscription.getAmountRounded().toStringAsFixed(2)}');
  print('Rata-rata harian (30 hari): Rp${subscription.getDailyAverage(30).toStringAsFixed(2)}');
  print('Proyeksi tahunan: Rp${subscription.projectedYearly().toStringAsFixed(2)}');
}