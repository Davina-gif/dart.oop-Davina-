// --- Definisi Class Expense Minimal ---
// Class ini diperlukan agar kode di main() dapat berjalan.
class Expense {
  final String description;
  final double amount;
  final String category;

  Expense(this.description, this.amount, this.category);

  // Named constructor yang diasumsikan (Expense.quick)
  Expense.quick({required this.description, required this.amount, required this.category});

  // Method yang diasumsikan (getSummary)
  String getSummary() {
    return '- [${category}] ${description}: ${amount.toStringAsFixed(2)}';
  }
}
// -------------------------------------


void main() {
  // Membuat list expenses
  List<Expense> expenses = [];

  // Menambah expenses menggunakan add()
  expenses.add(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  expenses.add(Expense.quick(description: 'Lunch', amount: 12.75, category: 'Food'));
  expenses.add(Expense.quick(description: 'Gas', amount: 45.00, category: 'Transport'));

  // Mengakses expenses
  print('--- Mengakses List ---');
  // Akses berdasarkan index: expenses[0]
  print('Expense pertama: \${expenses[0].description}'); 
  // Mendapatkan jumlah: expenses.length
  print('Total jumlah: \${expenses.length}'); 

  // Loop semua expenses
  print('\n--- Semua Expenses ---');
  // Loop menggunakan for-in
  for (var expense in expenses) {
    print(expense.getSummary());
  }

  // Menghapus expense menggunakan removeAt(index)
  // Indeks 'Lunch' adalah 1 (Coffee=0, Lunch=1, Gas=2)
  expenses.removeAt(1); 
  print('\n--- Operasi Hapus ---');
  print('Setelah hapus lunch: \${expenses.length} expenses');
  
  // Verifikasi (Gas sekarang menjadi indeks 1)
  print('Expense baru di indeks 1: \${expenses[1].description}');
  
  // Contoh Operasi List Lain: insert(index, item)
  print('\n--- Operasi Insert ---');
  expenses.insert(0, Expense.quick(description: 'Breakfast', amount: 5.00, category: 'Food'));
  print('Total setelah insert: \${expenses.length}');
  
  // Loop semua expenses setelah insert
  print('\n--- Semua Expenses Setelah Insert ---');
  for (var expense in expenses) {
    print(expense.getSummary());
  }
}