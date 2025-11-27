// Import dart:core untuk DateTime
import 'dart:core'; 

// =================================================================
// --- CLASS PENDUKUNG: Expense ---
// Definisi minimal yang diperlukan agar ExpenseManager dapat bekerja.
// =================================================================
class Expense {
  final String description;
  final double amount;
  final String category;
  final bool isPaid;
  final DateTime date; // Diperlukan jika Anda ingin menambahkan filter tanggal di masa mendatang

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    this.isPaid = false,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  // Method ini mungkin diperlukan oleh filter di bagian lain dari latihan.
  bool isMajorExpense() => amount >= 100.0;
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS UTAMA: ExpenseManager (Dilengkapi) ---
// =================================================================
class ExpenseManager {
  List<Expense> _expenses = []; //

  void addExpense(Expense expense) => _expenses.add(expense); //

  // Statistik Dasar
  int getCount() => _expenses.length; // Method Tambahan: Dapatkan jumlah total expense

  // Total pengeluaran
  double getTotalSpending() {
    double total = 0;
    for (var expense in _expenses) {
      total += expense.amount; //
    }
    return total;
  }

  // Total berdasarkan kategori
  double getTotalByCategory(String category) {
    double total = 0;
    for (var expense in _expenses) {
      if (expense.category == category) {
        total += expense.amount; //
      }
    }
    return total;
  }

  // Rata-rata jumlah expense
  double getAverageExpense() {
    if (_expenses.isEmpty) return 0;
    return getTotalSpending() / _expenses.length; //
  }

  // Expense terbesar
  Expense? getLargestExpense() {
    if (_expenses.isEmpty) return null;
    Expense largest = _expenses[0]; //
    for (var expense in _expenses) {
      if (expense.amount > largest.amount) {
        largest = expense;
      }
    }
    return largest;
  }

  // Expense terkecil
  Expense? getSmallestExpense() {
    if (_expenses.isEmpty) return null;
    Expense smallest = _expenses[0]; //
    for (var expense in _expenses) {
      if (expense.amount < smallest.amount) {
        smallest = expense;
      }
    }
    return smallest;
  }

  // Hitung berdasarkan kategori
  int countByCategory(String category) {
    int count = 0;
    for (var expense in _expenses) {
      if (expense.category == category) {
        count++; //
      }
    }
    return count;
  }

  // Dapatkan semua kategori unik
  List<String> getAllCategories() {
    List<String> categories = [];
    for (var expense in _expenses) {
      if (!categories.contains(expense.category)) {
        categories.add(expense.category); //
      }
    }
    return categories;
  }

  // Total yang belum dibayar
  double getTotalUnpaid() {
    double total = 0;
    for (var expense in _expenses) {
      if (!expense.isPaid) {
        total += expense.amount; //
      }
    }
    return total;
  }

  // Dapatkan breakdown kategori (map kategori -> total)
  Map<String, double> getCategoryBreakdown() {
    Map<String, double> breakdown = {};
    for (var expense in _expenses) {
      // Menggunakan operator null-aware untuk inisialisasi jika kunci belum ada
      breakdown[expense.category] = (breakdown[expense.category] ?? 0.0) + expense.amount; //
    }
    return breakdown;
  }
  
  // --- METHOD BARU: Filter berdasarkan rentang jumlah ---
  List<Expense> getByAmountRange(double min, double max) { //
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.amount >= min && expense.amount <= max) {
        filtered.add(expense);
      }
    }
    return filtered;
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  var manager = ExpenseManager();

  // Memasukkan data
  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', isPaid: true));
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics'));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food'));
  manager.addExpense(Expense(description: 'Gas', amount: 45.00, category: 'Transport'));

  print('📊 STATISTIK UTAMA:'); //
  print('Total expenses: ${manager.getCount()}'); // Uji getCount()
  print('Total pengeluaran: Rp${manager.getTotalSpending().toStringAsFixed(2)}');
  print('Rata-rata expense: Rp${manager.getAverageExpense().toStringAsFixed(2)}');
  print('Total belum dibayar: Rp${manager.getTotalUnpaid().toStringAsFixed(2)}');

  var largest = manager.getLargestExpense();
  if (largest != null) {
    print('Terbesar: ${largest.description} - Rp${largest.amount.toStringAsFixed(2)}'); //
  }

  print('\n📁 BREAKDOWN KATEGORI:');
  var breakdown = manager.getCategoryBreakdown();
  breakdown.forEach((category, total) {
    print('$category: Rp${total.toStringAsFixed(2)} (Total ${manager.countByCategory(category)})');
  });
  
  // Uji Method Baru: getByAmountRange
  print('\n🔎 FILTER BERDASARKAN JUMLAH (Rp10 - Rp50):');
  var mediumExpenses = manager.getByAmountRange(10.0, 50.0);
  for (var expense in mediumExpenses) {
    print('• ${expense.description}: Rp${expense.amount.toStringAsFixed(2)}');
  }
}