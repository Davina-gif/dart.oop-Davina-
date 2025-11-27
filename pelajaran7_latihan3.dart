import 'dart:core';

// Mendapatkan tanggal hari ini (hanya untuk testing kode)
final _today = DateTime.now();

// =================================================================
// --- CLASS LEVEL 1: Expense (Superclass Dasar) ---
// =================================================================
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  void printDetails() {
    print('  Deskripsi: $description');
    print('  Jumlah: Rp${amount.toStringAsFixed(2)}');
    print('  Kategori: $category');
    print('  Tanggal: ${date.toLocal().toString().split(' ')[0]}');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS LEVEL 2: RecurringExpense (Superclass Langganan) ---
// Dibutuhkan karena SubscriptionExpense meng-extend class ini
// Method yearlyTotal() harus didefinisikan di sini.
// =================================================================
class RecurringExpense extends Expense {
  final String frequency; // Contoh: 'harian', 'bulanan', 'tahunan'

  RecurringExpense({
    required String description,
    required double amount,
    required String category,
    required this.frequency,
    DateTime? date,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          date: date ?? _today,
        );

  // Method yang DIBUTUHKAN oleh SubscriptionExpense.getTotalCost()
  double yearlyTotal() {
    switch (frequency.toLowerCase()) {
      case 'bulanan':
        return amount * 12;
      case 'tahunan':
        return amount;
      default:
        return amount; // Jika frekuensi tidak diketahui, anggap itu biaya satu kali
    }
  }

  @override
  void printDetails() {
    super.printDetails();
    print('  Frekuensi: $frequency');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS LEVEL 3: SubscriptionExpense (Subclass Final) ---
// (Kode Anda, disesuaikan sedikit untuk akurasi tanggal)
// =================================================================
class SubscriptionExpense extends RecurringExpense {
  String provider;
  String plan;
  DateTime startDate;
  DateTime? endDate;

  SubscriptionExpense({
    required String description,
    required double amount,
    required this.provider,
    required this.plan,
    required this.startDate,
    this.endDate,
  }) : super(
          description: description,
          amount: amount,
          category: 'Langganan',
          frequency: 'bulanan',
          date: startDate, // Gunakan startDate sebagai tanggal utama
        );

  // Method: isActive() - cek apakah subscription masih aktif
  bool isActive() {
    DateTime now = _today; 
    if (endDate == null) return true; // Tidak ada end date = aktif
    
    // Gunakan isAfter untuk membandingkan tanggal akhir vs hari ini
    // (Jika hari ini adalah tanggal berakhir, biasanya masih aktif)
    return now.isBefore(endDate!) || now.isAtSameMomentAs(endDate!);
  }

  // Method: getRemainingMonths() - bulan sampai expired
  int getRemainingMonths() {
    if (endDate == null) return -1; // -1 untuk tidak terbatas
    
    DateTime now = _today;
    if (now.isAfter(endDate!)) return 0;

    // Perhitungan bulan yang lebih akurat
    int years = endDate!.year - now.year;
    int months = endDate!.month - now.month;
    
    // Jika bulan berakhir lebih kecil dari bulan sekarang, berarti perlu mengurangi 1 tahun
    if (endDate!.day < now.day && months > 0) {
        months--;
    }

    return years * 12 + months;
  }

  // Method: getTotalCost() - total biaya dari start sampai end date
  double getTotalCost() {
    if (endDate == null) {
      // Jika tidak ada end date, hitung proyeksi untuk 1 tahun ke depan
      return yearlyTotal();
    }

    // Hitung total bulan dari startDate sampai endDate
    int years = endDate!.year - startDate.year;
    int months = endDate!.month - startDate.month;
    
    int totalMonths = years * 12 + months;
    
    // Pastikan total bulan >= 1
    if (totalMonths <= 0) return amount; 
    
    return amount * totalMonths;
  }

  @override
  void printDetails() {
    print('📱 LANGGANAN');
    print('$description ($provider - $plan)');
    print('Biaya: Rp ${amount.toStringAsFixed(2)}/bulan');
    print('Mulai: ${startDate.toString().split(' ')[0]}');

    final remainingMonths = getRemainingMonths();

    if (endDate != null) {
      print('Berakhir: ${endDate!.toString().split(' ')[0]}');
      if (remainingMonths > 0) {
        print('Sisa: $remainingMonths bulan');
      }
    } else {
      print('Berakhir: Tidak terbatas');
    }

    print('Status: ${isActive() ? "Aktif ✅" : "Expired ❌"}');
    print('Total Biaya (dari awal s.d. akhir/1 thn): Rp ${getTotalCost().toStringAsFixed(2)}');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  // Atur tanggal hari ini ke waktu yang dapat diprediksi untuk pengujian
  // Catatan: Karena _today final, kita tidak bisa mengubahnya di sini, 
  // jadi kita berasumsi tanggal hari ini adalah seperti yang diambil di atas.
  
  print('Tanggal Hari Ini (untuk perhitungan): ${_today.toLocal().toString().split(' ')[0]}');
  print('-----------------------------------------');

  // Contoh 1: Langganan Berkelanjutan
  var netflix = SubscriptionExpense(
    description: 'Netflix Premium',
    amount: 186000,
    provider: 'Netflix',
    plan: 'Premium 4K',
    startDate: DateTime(_today.year - 1, _today.month, 1), 
    endDate: null,  // Berkelanjutan
  );

  // Contoh 2: Langganan Berakhir di masa depan
  var trial = SubscriptionExpense(
    description: 'Adobe Creative Cloud',
    amount: 800000,
    provider: 'Adobe',
    plan: 'Semua Apps',
    startDate: DateTime(_today.year, _today.month - 2, 1),
    endDate: DateTime(_today.year, _today.month + 3, 30), // Berakhir 3 bulan dari sekarang
  );
  
  // Contoh 3: Langganan yang sudah Expired
  var expired = SubscriptionExpense(
    description: 'Majalah X',
    amount: 50000,
    provider: 'Penerbit',
    plan: '12 bulan',
    startDate: DateTime(_today.year - 2, 1, 1),
    endDate: DateTime(_today.year - 1, 1, 1), // Berakhir tahun lalu
  );


  netflix.printDetails();
  print('\n-----------------------------------------');
  trial.printDetails();
  print('\n-----------------------------------------');
  expired.printDetails();
}