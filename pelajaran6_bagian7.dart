import 'dart:core';

// =================================================================
// --- CLASS PENDUKUNG: Expense (Lengkap) ---
// Method isMajorExpense, isThisMonth, getFullDisplay, dan getSummary
// ditambahkan untuk mendukung ExpenseManager.
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
    this.isPaid = false,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  // Method yang dibutuhkan oleh ExpenseManager.getMajorExpenses()
  bool isMajorExpense() => amount >= 100.0;

  // Method yang dibutuhkan oleh ExpenseManager.getThisMonth()
  bool isThisMonth() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
  
  // Method yang dibutuhkan oleh ExpenseManager.printAllExpenses()
  String getFullDisplay() {
    final status = isPaid ? 'Lunas' : 'Belum Bayar';
    final formattedDate = '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
    return '[${category.padRight(12)}] Rp${amount.toStringAsFixed(2).padLeft(10)} - ${description} (${formattedDate} | ${status})';
  }

  // Method yang dibutuhkan oleh main() dan report methods
  String getSummary() {
    return '${description.padRight(10)}: Rp${amount.toStringAsFixed(2)} [${category}]';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS UTAMA: ExpenseManager (Final) ---
// (Kode Anda, disalin untuk kelengkapan)
// =================================================================
class ExpenseManager {
  List<Expense> _expenses = [];

  // === METHOD TAMBAH ===
  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  void addMultipleExpenses(List<Expense> expenses) {
    _expenses.addAll(expenses);
    print('✅ Ditambahkan ${expenses.length} expenses');
  }

  // === METHOD GET ===
  List<Expense> getAllExpenses() => List.from(_expenses);

  int getCount() => _expenses.length;

  bool isEmpty() => _expenses.isEmpty;

  Expense? getExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) return null;
    return _expenses[index];
  }

  // === METHOD FILTER ===
  List<Expense> getByCategory(String category) {
    return _expenses.where((e) => e.category.toLowerCase() == category.toLowerCase()).toList();
  }

  List<Expense> getByAmountRange(double min, double max) {
    return _expenses.where((e) => e.amount >= min && e.amount <= max).toList();
  }

  List<Expense> getMajorExpenses() {
    return _expenses.where((e) => e.isMajorExpense()).toList();
  }

  List<Expense> getThisMonth() {
    return _expenses.where((e) => e.isThisMonth()).toList();
  }

  List<Expense> getPaidExpenses() {
    return _expenses.where((e) => e.isPaid).toList();
  }

  List<Expense> getUnpaidExpenses() {
    return _expenses.where((e) => !e.isPaid).toList();
  }

  // === METHOD STATISTIK ===
  double getTotalSpending() {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  double getTotalByCategory(String category) {
    return _expenses
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double getAverageExpense() {
    if (_expenses.isEmpty) return 0;
    return getTotalSpending() / _expenses.length;
  }

  double getTotalUnpaid() {
    return _expenses
        .where((e) => !e.isPaid)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Expense? getLargestExpense() {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  Expense? getSmallestExpense() {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount < b.amount ? a : b);
  }

  int countByCategory(String category) {
    return _expenses.where((e) => e.category.toLowerCase() == category.toLowerCase()).length;
  }

  List<String> getAllCategories() {
    return _expenses.map((e) => e.category).toSet().toList();
  }

  Map<String, double> getCategoryBreakdown() {
    Map<String, double> breakdown = {};
    for (var expense in _expenses) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  Map<String, int> getCategoryCounts() {
    Map<String, int> counts = {};
    for (var expense in _expenses) {
      counts[expense.category] = (counts[expense.category] ?? 0) + 1;
    }
    return counts;
  }

  // === METHOD SORT ===
  List<Expense> sortByAmountDesc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }

  List<Expense> sortByAmountAsc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.amount.compareTo(b.amount));
    return sorted;
  }

  List<Expense> sortByDateDesc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<Expense> sortByCategory() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.category.compareTo(b.category));
    return sorted;
  }

  // === METHOD HAPUS ===
  bool removeExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) return false;
    _expenses.removeAt(index);
    return true;
  }

  bool removeExpenseByDescription(String description) {
    int initialLength = _expenses.length;
    _expenses.removeWhere((e) => e.description == description);
    return _expenses.length < initialLength;
  }

  int removeByCategory(String category) {
    int initialLength = _expenses.length;
    _expenses.removeWhere((e) => e.category.toLowerCase() == category.toLowerCase());
    return initialLength - _expenses.length;
  }

  void clearAll() {
    _expenses.clear();
  }

  // === METHOD PENCARIAN ===
  List<Expense> searchByDescription(String query) {
    String lowerQuery = query.toLowerCase();
    return _expenses
        .where((e) => e.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  int findIndexByDescription(String description) {
    return _expenses.indexWhere((e) => e.description == description);
  }

  // === METHOD LAPORAN ===
  void printSummary() {
    print('\n═══════════════════════════════════');
    print('💰 RINGKASAN PENGELUARAN');
    print('═══════════════════════════════════');
    print('Total expenses: ${getCount()}');
    print('Total yang dikeluarkan: Rp${getTotalSpending().toStringAsFixed(2)}');
    print('Rata-rata expense: Rp${getAverageExpense().toStringAsFixed(2)}');
    print('Total belum dibayar: Rp${getTotalUnpaid().toStringAsFixed(2)}');

    var largest = getLargestExpense();
    if (largest != null) {
      print('Terbesar: ${largest.description} (Rp${largest.amount.toStringAsFixed(2)})');
    }

    print('═══════════════════════════════════\n');
  }

  void printCategoryReport() {
    print('\n📊 BREAKDOWN KATEGORI\n');
    var breakdown = getCategoryBreakdown();
    var counts = getCategoryCounts();
    double total = getTotalSpending();

    if (total == 0) {
        print("Tidak ada pengeluaran.");
        return;
    }

    // Mengurutkan kategori berdasarkan jumlah uang yang dikeluarkan
    var sortedCategories = breakdown.keys.toList()
        ..sort((a, b) => breakdown[b]!.compareTo(breakdown[a]!));

    for (var category in sortedCategories) {
      double amount = breakdown[category]!;
      double percentage = (amount / total) * 100;
      int count = counts[category] ?? 0;
      print('• ${category}:');
      print('  Jumlah: Rp${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)');
      print('  Banyak: $count expenses');
      print('');
    }
  }

  void printAllExpenses() {
    print('\n📋 SEMUA EXPENSES\n');
    if (_expenses.isEmpty) {
      print('Tidak ada expenses untuk ditampilkan');
      return;
    }

    // Mencetak expenses yang diurutkan berdasarkan tanggal terbaru
    var sortedExpenses = sortByDateDesc();
    for (int i = 0; i < sortedExpenses.length; i++) {
      print('${i + 1}. ${sortedExpenses[i].getFullDisplay()}');
    }
    print('');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  var manager = ExpenseManager();
  final now = DateTime.now();

  // Tambah expenses
  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food', date: now.subtract(Duration(days: 3))));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', isPaid: true, date: now.subtract(Duration(days: 10))));
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics', date: now.subtract(Duration(days: 5))));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food', date: now.subtract(Duration(days: 2))));
  manager.addExpense(Expense(description: 'Gas', amount: 45.00, category: 'Transport', date: now.subtract(Duration(days: 1))));
  manager.addExpense(Expense(description: 'Groceries', amount: 127.50, category: 'Food', isPaid: true, date: now.subtract(Duration(days: 8))));

  // Print laporan
  manager.printSummary();
  manager.printCategoryReport();
  manager.printAllExpenses();

  // Filter dan tampilkan
  print('🍔 EXPENSES MAKANAN:');
  for (var expense in manager.getByCategory('Food')) {
    print('  ${expense.getSummary()}');
  }

  print('\n🔴 MAJOR EXPENSES (>= Rp100):');
  for (var expense in manager.getMajorExpenses()) {
    print('  ${expense.getSummary()}');
  }
  
  // Uji pencarian
  print('\n🔎 HASIL PENCARIAN "Lap":');
  for (var expense in manager.searchByDescription('Lap')) {
    print('  ${expense.getSummary()}');
  }

  // Uji penghapusan
  print('\n--- UJI HAPUS ---');
  manager.removeByCategory('Bills');
  manager.printSummary();
}