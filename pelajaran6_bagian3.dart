// Import dart:core untuk DateTime.now()
import 'dart:core'; 

// --- DEFINISI CLASS PENDUKUNG: Expense ---
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final bool isPaid;

  // Constructor yang digunakan oleh ExpenseManager.addExpense
  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    this.isPaid = false,
  }) : this.date = date ?? DateTime.now();
  
  // Named constructor Expense.quick yang digunakan di main()
  Expense.quick({required this.description, required this.amount, required this.category})
      : this(description: description, amount: amount, category: category, date: DateTime.now(), isPaid: false);

  // Method yang diasumsikan untuk filtering (isMajorExpense)
  bool isMajorExpense() {
    // Definisi: Pengeluaran dianggap besar (Major) jika di atas Rp100
    return amount >= 100.0;
  }

  // Method yang diasumsikan untuk filtering (isThisMonth)
  bool isThisMonth() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Method getSummary()
  String getSummary() {
    final status = isPaid ? 'Lunas' : 'Belum Bayar';
    return '• [${category}] ${description}: Rp${amount.toStringAsFixed(2)} (${status})';
  }
}
// ------------------------------------------------------------------

// --- DEFINISI CLASS UTAMA: ExpenseManager ---
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  // Menggunakan List.from() untuk mengembalikan salinan list
  List<Expense> getAllExpenses() => List.from(_expenses);

  // 1. Filter berdasarkan kategori
  List<Expense> getByCategory(String category) {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.category.toLowerCase() == category.toLowerCase()) {
        filtered.add(expense);
      }
    }
    return filtered;
    // Catatan: Ini dapat disingkat menggunakan _expenses.where((e) => e.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // 2. Filter berdasarkan rentang jumlah (getByAmountRange)
  List<Expense> getByAmountRange(double min, double max) {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.amount >= min && expense.amount <= max) {
        filtered.add(expense);
      }
    }
    return filtered;
  }
  
  // 3. Dapatkan major expenses saja
  List<Expense> getMajorExpenses() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.isMajorExpense()) {
        filtered.add(expense);
      }
    }
    return filtered;
  }
  
  // 4. Dapatkan expenses bulan ini
  List<Expense> getThisMonth() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.isThisMonth()) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  // 5. Dapatkan expenses yang sudah dibayar
  List<Expense> getPaidExpenses() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.isPaid) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  // 6. Dapatkan expenses yang belum dibayar
  List<Expense> getUnpaidExpenses() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (!expense.isPaid) { // !expense.isPaid berarti false
        filtered.add(expense);
      }
    }
    return filtered;
  }
}
// ------------------------------------------------------------------


void main() {
  var manager = ExpenseManager();
  final now = DateTime.now();

  // Menambahkan data expense
  manager.addExpense(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', isPaid: true, date: DateTime(now.year, now.month, 5))); // Bulan ini
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics', date: DateTime(now.year - 1, 10, 1))); // Tahun lalu
  manager.addExpense(Expense.quick(description: 'Lunch', amount: 15.75, category: 'Food'));

  print('--- HASIL FILTER ---');

  // 1. Uji getByCategory
  print('\nEXPENSES MAKANAN:');
  for (var expense in manager.getByCategory('Food')) {
    print(expense.getSummary());
  }
  
  // 2. Uji getMajorExpenses (amount >= 100)
  print('\nMAJOR EXPENSES (>Rp100):');
  for (var expense in manager.getMajorExpenses()) {
    print(expense.getSummary());
  }
  
  // 3. Uji getUnpaidExpenses (isPaid = false)
  print('\nEXPENSES BELUM DIBAYAR:');
  for (var expense in manager.getUnpaidExpenses()) {
    print(expense.getSummary());
  }

  // 4. Uji getThisMonth
  print('\nEXPENSES BULAN INI:');
  for (var expense in manager.getThisMonth()) {
    print(expense.getSummary());
  }
}