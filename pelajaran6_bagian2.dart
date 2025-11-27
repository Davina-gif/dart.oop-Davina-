// --- DEFINISI CLASS PENDUKUNG: Expense ---
// Class Expense minimalis diperlukan untuk mendukung ExpenseManager.
class Expense {
  final String description;
  final double amount;
  final String category;

  // Constructor utama
  Expense(this.description, this.amount, this.category);
  
  // Named constructor Expense.quick yang digunakan di main()
  Expense.quick({required this.description, required this.amount, required this.category});

  // Method getSummary() yang digunakan di main()
  String getSummary() {
    return '🟢 ${description}: Rp${amount.toStringAsFixed(2)} [${category}]';
  }
}
// ------------------------------------------------------------------

// --- DEFINISI CLASS UTAMA: ExpenseManager ---
class ExpenseManager {
  // List private untuk menyimpan semua expenses
  List<Expense> _expenses = [];

  // Named Constructor 'quick' yang diasumsikan digunakan di main()
  ExpenseManager.quick();
  
  // Constructor default
  ExpenseManager();

  // Tambah expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    print('✅ Ditambahkan: ${expense.description}');
  }

  // Dapatkan semua expenses (return copy untuk melindungi list internal)
  List<Expense> getAllExpenses() {
    // Menggunakan List.from() untuk mengembalikan salinan
    return List.from(_expenses); 
  }

  // Dapatkan total jumlah expenses
  int getCount() {
    return _expenses.length;
  }

  // Hitung total pengeluaran
  double getTotalSpending() {
    double total = 0;
    for (var expense in _expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Print ringkasan sederhana
  void printSummary() {
    print('\n👍 RINGKASAN PENGELUARAN');
    print('Total expenses: ${getCount()}');
    print('Total yang dikeluarkan: Rp${getTotalSpending().toStringAsFixed(2)}');
  }
}
// ------------------------------------------------------------------

void main() {
  // Menggunakan constructor default (asumsi)
  var manager = ExpenseManager(); 

  // Menambahkan data expense
  manager.addExpense(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense.quick(description: 'Uber', amount: 12.00, category: 'Transport'));
  manager.addExpense(Expense.quick(description: 'Lunch', amount: 15.75, category: 'Food'));

  manager.printSummary();

  print('\nSemua expenses:');
  // Loop menggunakan getAllExpenses() untuk mengakses data
  for (var expense in manager.getAllExpenses()) {
    print(expense.getSummary());
  }
}