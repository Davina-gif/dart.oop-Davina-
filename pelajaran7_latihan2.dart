import 'dart:core';

// =================================================================
// --- CLASS INDUK (SUPERCLASS): Expense ---
// Harus ada agar TravelExpense dapat meng-extend dan memanggil super.printDetails()
// =================================================================
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final bool isPaid;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.isPaid = false,
  });

  // Method yang DIBUTUHKAN oleh TravelExpense karena dipanggil dengan super.printDetails()
  void printDetails() {
    print('  Deskripsi: $description');
    print('  Jumlah: Rp${amount.toStringAsFixed(2)}');
    print('  Kategori: $category');
    print('  Tanggal: ${date.toLocal().toString().split(' ')[0]}');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS ANAK (SUBCLASS): TravelExpense ---
// (Kode Anda)
// =================================================================
class TravelExpense extends Expense {
  String destination;
  int tripDuration;

  TravelExpense({
    required String description,
    required double amount,
    required this.destination,
    required this.tripDuration,
    DateTime? date,
  }) : super(
          description: description,
          amount: amount,
          category: 'Perjalanan', // Default category
          date: date ?? DateTime.now(),
        );

  // Method: getDailyCost() - Biaya per hari
  double getDailyCost() {
    // Perbaikan: Mencegah pembagian dengan nol jika tripDuration <= 0
    if (tripDuration <= 0) return amount;
    return amount / tripDuration;
  }

  // Method: isInternational() - Cek sederhana
  bool isInternational() {
    final lowerDestination = destination.toLowerCase();
    
    // Cek sederhana - bisa diperbaiki dengan list negara atau API geografis
    return lowerDestination.contains('jepang') ||
           lowerDestination.contains('singapura') ||
           lowerDestination.contains('malaysia') ||
           lowerDestination.contains('korea') ||
           lowerDestination.contains('usa') ||
           lowerDestination.contains('inggris');
  }

  @override
  void printDetails() {
    print('✈️ PENGELUARAN PERJALANAN');
    super.printDetails(); // Panggil implementasi dari kelas induk (Expense)
    print('  Destinasi: $destination');
    print('  Durasi: $tripDuration hari');
    print('  Biaya harian: Rp ${getDailyCost().toStringAsFixed(2)}');
    print('  Internasional: ${isInternational() ? "Ya 🌍" : "Tidak 🏠"}');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  // Contoh 1: Perjalanan Internasional
  var tripInternational = TravelExpense(
    description: 'Liburan Tokyo',
    amount: 25000000.0,
    destination: 'Tokyo, Jepang',
    tripDuration: 7,
  );

  tripInternational.printDetails();

  print('\n---------------------------------');

  // Contoh 2: Perjalanan Domestik
  var tripDomestic = TravelExpense(
    description: 'Dinas Jakarta-Surabaya',
    amount: 5500000.0,
    destination: 'Surabaya, Indonesia',
    tripDuration: 3,
    date: DateTime(2025, 12, 1),
  );
  tripDomestic.printDetails();
}