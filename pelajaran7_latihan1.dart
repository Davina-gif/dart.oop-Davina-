import 'dart:core';

// =================================================================
// --- CLASS INDUK (SUPERCLASS): Expense ---
// Harus ada agar BusinessExpense dapat meng-extend dan memanggil super.printDetails()
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

  // Method yang DIBUTUHKAN oleh BusinessExpense karena dipanggil dengan super.printDetails()
  void printDetails() {
    print('  Deskripsi: $description');
    print('  Jumlah: Rp${amount.toStringAsFixed(2)}');
    print('  Kategori: $category');
    print('  Tanggal: ${date.toLocal().toString().split(' ')[0]}');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS ANAK (SUBCLASS): BusinessExpense ---
// =================================================================
class BusinessExpense extends Expense {
  String client;
  bool isReimbursable;

  BusinessExpense({
    required String description,
    required double amount,
    required String category,
    required this.client,
    this.isReimbursable = true,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          date: DateTime.now(),
        );

  @override
  void printDetails() {
    print('💼 PENGELUARAN BISNIS');
    // Memanggil implementasi printDetails() dari class Expense
    super.printDetails(); 
    print('  Klien: $client');
    print('  Bisa di-reimburse: ${isReimbursable ? "Ya ✅" : "Tidak ❌"}');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  var expense = BusinessExpense(
    description: 'Makan siang klien',
    amount: 85.0,
    category: 'Makan',
    client: 'PT Acme',
    isReimbursable: true,
  );

  expense.printDetails();
  
  print('\n--- Expense Lain ---');
  var nonReimbursable = BusinessExpense(
    description: 'Biaya parkir',
    amount: 5.50,
    category: 'Transport',
    client: 'PT Nebula',
    isReimbursable: false,
  );
  nonReimbursable.printDetails();
}