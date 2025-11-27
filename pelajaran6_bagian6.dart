import 'dart:core';

// =================================================================
// --- CLASS PENDUKUNG: Expense ---
// Definisi minimal agar main() dan ExpenseManager dapat berjalan
// =================================================================
class Expense {
  final String description;
  final double amount;
  final String category;
  final bool isPaid;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    this.isPaid = false,
  });

  // Named constructor yang digunakan di main()
  Expense.quick({
    required this.description,
    required this.amount,
    required this.category,
  }) : this(description: description, amount: amount, category: category) 

  // Method yang digunakan di main() untuk mencetak ringkasan
  String getSummary() {
    return '• ${description.padRight(10)}: Rp${amount.toStringAsFixed(2)} [${category}]';
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS UTAMA: ExpenseManager (Menghapus & Mengupdate) ---
// =================================================================
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
    print('✅ Ditambahkan: ${expense.description}');
  }
  
  // Method tambahan untuk debugging
  List<Expense> getAllExpenses() => List.from(_expenses);

  // Hapus expense berdasarkan index
  bool removeExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) {
      print('❌ Index tidak valid');
      return false;
    }
    var removed = _expenses.removeAt(index);
    print('🗑️ Dihapus: ${removed.description}');
    return true;
  }

  // Hapus expense berdasarkan deskripsi
  bool removeExpenseByDescription(String description) {
    // Menggunakan removeWhere pada list copy atau for loop yang dioptimalkan
    // Implementasi for loop yang Anda berikan sudah benar dan aman.
    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].description == description) {
        var removed = _expenses.removeAt(i);
        print('🗑️ Dihapus: ${removed.description}');
        return true;
      }
    }
    print('❌ Expense tidak ditemukan: $description');
    return false;
  }

  // Hapus semua expenses di kategori tertentu
  int removeByCategory(String category) {
    int count = 0;
    // Menggunakan removeWhere adalah cara paling efisien di Dart
    _expenses.removeWhere((expense) {
      if (expense.category.toLowerCase() == category.toLowerCase()) {
        count++;
        return true;
      }
      return false;
    });
    print('🗑️ Dihapus $count expenses dari kategori: $category');
    return count;
  }

  // Bersihkan semua expenses
  void clearAll() {
    int count = _expenses.length;
    _expenses.clear();
    print('🗑️ Dibersihkan semua $count expenses');
  }

  // Update expense di index tertentu
  bool updateExpense(int index, Expense newExpense) {
    if (index < 0 || index >= _expenses.length) {
      print('❌ Index tidak valid');
      return false;
    }
    _expenses[index] = newExpense;
    print('✏️ Expense diupdate di index $index');
    return true;
  }

  // Dapatkan expense berdasarkan index
  Expense? getExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) {
      return null;
    }
    return _expenses[index];
  }

  // Cari index expense berdasarkan deskripsi
  int findIndexByDescription(String description) {
    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].description == description) {
        return i;
      }
    }
    return -1;
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  var manager = ExpenseManager();

  // Menambahkan 3 expense
  manager.addExpense(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense.quick(description: 'Lunch', amount: 15.75, category: 'Food'));
  manager.addExpense(Expense.quick(description: 'Gas', amount: 45.00, category: 'Transport'));

  print('\n--- Menghapus ---');
  // Hapus "Coffee" (Index 0)
  manager.removeExpenseByDescription('Coffee'); 

  print('\n--- Mengupdate ---');
  // Cari "Lunch" (Sekarang Index 0)
  int index = manager.findIndexByDescription('Lunch'); 
  if (index != -1) {
    // Update Lunch menjadi Dinner
    manager.updateExpense(index, Expense.quick(description: 'Dinner', amount: 25.00, category: 'Food'));
  }

  print('\n--- Penghapusan Massal ---');
  manager.addExpense(Expense.quick(description: 'Bus Ticket', amount: 5.00, category: 'Transport'));
  manager.removeByCategory('Transport'); // Hapus "Gas" dan "Bus Ticket"

  print('\n--- List akhir ---');
  if (manager.getAllExpenses().isEmpty) {
    print('List expense kosong.');
  } else {
    for (var expense in manager.getAllExpenses()) {
      print(expense.getSummary());
    }
  }
}