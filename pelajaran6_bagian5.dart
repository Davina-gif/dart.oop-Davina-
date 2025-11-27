import 'dart:core';

// =================================================================
// --- CLASS PENDUKUNG: Expense ---
// Definisi minimal yang diperlukan untuk mendukung sorting
// =================================================================
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final bool isPaid; // Properti ini dibutuhkan jika ada method lain yang menggunakannya

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.isPaid = false,
  });

  // Method yang dibutuhkan di main() untuk mencetak tanggal
  String getFormattedDate() {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS UTAMA: ExpenseManager (Method Sorting) ---
// =================================================================
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) => _expenses.add(expense);
  List<Expense> getAllExpenses() => List.from(_expenses); // Mengembalikan salinan

  // Urutkan berdasarkan jumlah (ascending)
  List<Expense> sortByAmountAsc() {
    List<Expense> sorted = List.from(_expenses);
    // Menggunakan compareTo untuk perbandingan double secara ascending
    sorted.sort((a, b) => a.amount.compareTo(b.amount)); 
    return sorted;
  }

  // Urutkan berdasarkan jumlah (descending)
  List<Expense> sortByAmountDesc() {
    List<Expense> sorted = List.from(_expenses);
    // Membalik urutan b.amount.compareTo(a.amount)
    sorted.sort((a, b) => b.amount.compareTo(a.amount)); 
    return sorted;
  }

  // Urutkan berdasarkan tanggal (terbaru dulu / descending)
  List<Expense> sortByDateDesc() {
    List<Expense> sorted = List.from(_expenses);
    // b.date.compareTo(a.date) menghasilkan descending order (terbaru ke terlama)
    sorted.sort((a, b) => b.date.compareTo(a.date)); 
    return sorted;
  }

  // Urutkan berdasarkan tanggal (terlama dulu / ascending)
  List<Expense> sortByDateAsc() {
    List<Expense> sorted = List.from(_expenses);
    // a.date.compareTo(b.date) menghasilkan ascending order (terlama ke terbaru)
    sorted.sort((a, b) => a.date.compareTo(b.date)); 
    return sorted;
  }

  // Urutkan berdasarkan kategori (ascending)
  List<Expense> sortByCategory() {
    List<Expense> sorted = List.from(_expenses);
    // Menggunakan compareTo untuk perbandingan string
    sorted.sort((a, b) => a.category.compareTo(b.category)); 
    return sorted;
  }

  // Urutkan berdasarkan deskripsi (ascending)
  List<Expense> sortByDescription() {
    List<Expense> sorted = List.from(_expenses);
    // Menggunakan compareTo untuk perbandingan string
    sorted.sort((a, b) => a.description.compareTo(b.description)); 
    return sorted;
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  var manager = ExpenseManager();

  // Memasukkan data dengan tanggal berbeda
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics', date: DateTime(2025, 10, 5)));
  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food', date: DateTime(2025, 10, 9)));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', date: DateTime(2025, 10, 1)));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food', date: DateTime(2025, 10, 8)));

  print('--- HASIL PENGURUTAN ---');
  
  print('\n💵 DIURUTKAN BERDASARKAN JUMLAH (tertinggi dulu):');
  for (var expense in manager.sortByAmountDesc()) {
    print('${expense.description.padRight(10)}: Rp${expense.amount.toStringAsFixed(2)}');
  }

  print('\n🗓️ DIURUTKAN BERDASARKAN TANGGAL (terbaru dulu):');
  for (var expense in manager.sortByDateDesc()) {
    print('${expense.getFormattedDate()}: ${expense.description}');
  }

  print('\n🏷️ DIURUTKAN BERDASARKAN KATEGORI (A-Z):');
  for (var expense in manager.sortByCategory()) {
    print('${expense.category.padRight(12)}: ${expense.description}');
  }
}