// Menggunakan named constructor untuk memudahkan inisialisasi
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date; // Properti tanggal untuk digunakan oleh method

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  // 1. Method: getWeekNumber()
  // Mengembalikan nomor minggu dalam tahun (sesuai standar ISO 8601 atau yang mendekati).
  int getWeekNumber() {
    // Menghitung hari ke-tahun (dayOfYear)
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    
    // Perhitungan sederhana: membagi hari ke-tahun dengan 7
    // Tambahan: Pembulatan ke atas (ceil) lebih akurat untuk nomor minggu.
    return (dayOfYear / 7).ceil();
    
    // Catatan: Jika Anda ingin menggunakan standar ISO 8601 yang ketat (seperti yang mungkin dimaksud di solusi asli), 
    // Anda perlu menggunakan package 'intl' atau logika yang lebih kompleks.
    // Solusi ini memberikan nomor minggu berbasis 1 Januari.
  }

  // 2. Method: getQuarter()
  // Mengembalikan kuartal (1-4) dari pengeluaran
  int getQuarter() {
    // Kuartal 1: Bulan 1-3
    // Kuartal 2: Bulan 4-6
    // Kuartal 3: Bulan 7-9
    // Kuartal 4: Bulan 10-12
    return ((date.month - 1) ~/ 3) + 1; // Operator ~/ adalah integer division
  }

  // 3. Method: isWeekend()
  // Mengembalikan true jika pengeluaran di hari Sabtu atau Minggu
  bool isWeekend() {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
}

void main() {
  // Contoh penggunaan
  var expense = Expense(
    description: 'Brunch akhir pekan',
    amount: 45.00,
    category: 'Makanan',
    // Tanggal 10 November 2025 adalah Hari Senin
    date: DateTime(2025, 11, 10), 
  );
  
  // Contoh dengan tanggal di akhir pekan: 15 November 2025 adalah Hari Sabtu
  var weekendExpense = Expense(
    description: 'Weekend Trip',
    amount: 200.00,
    category: 'Travel',
    date: DateTime(2025, 11, 15), 
  );

  print('--- Expense 1: ${expense.description} ---');
  print('Nomor Minggu: ${expense.getWeekNumber()}'); // Sekitar minggu ke-45/46
  print('Kuartal: ${expense.getQuarter()}');       // Kuartal 4
  print('Akhir Pekan? ${expense.isWeekend()}');     // false

  print('\n--- Expense 2: ${weekendExpense.description} ---');
  print('Akhir Pekan? ${weekendExpense.isWeekend()}'); // true
}