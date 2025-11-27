import 'dart:core';

// Anggap class ExpenseManager sudah tersedia dan berfungsi
// (Di sini hanya definisi minimal agar BudgetManager bisa dikompilasi)
class ExpenseManager {
  // Method dummy yang harus ada di ExpenseManager Anda
  double getTotalByCategory(String category) { 
    // Diimplementasikan di ExpenseManager sebenarnya
    return 0.0; 
  }
  List<String> getAllCategories() { 
    return [];
  } 
  // ... method lain ...
}


class BudgetManager {
  // Map untuk menyimpan limit budget per kategori: { 'Kategori': LimitDouble }
  final Map<String, double> _budgets = {}; 
  
  // Instance dari ExpenseManager untuk mengambil data pengeluaran
  final ExpenseManager expenseManager; 
  
  // Persentase warning, misal 0.8 berarti 80% dari budget
  static const double WARNING_THRESHOLD = 0.8; 

  BudgetManager(this.expenseManager);

  // === 1. SET BUDGET ===
  void setBudget(String category, double limit) {
    if (limit < 0) {
      print('❌ Limit budget harus positif.');
      return;
    }
    _budgets[category] = limit;
    print('✅ Budget kategori "$category" diatur menjadi Rp${limit.toStringAsFixed(2)}.');
  }

  // === 2. GET STATUS & TRACKING ===
  double getCategorySpending(String category) {
    // Meminta total pengeluaran dari ExpenseManager
    return expenseManager.getTotalByCategory(category); 
  }
  
  double getRemainingBudget(String category) {
    double limit = _budgets[category] ?? 0.0;
    double spending = getCategorySpending(category);
    return limit - spending;
  }
  
  // === 3. WARNING/ALERT ===
  void checkAlerts() {
    print('\n🔔 MEMERIKSA PERINGATAN BUDGET...');
    bool hasAlert = false;
    
    // Iterasi melalui setiap kategori yang memiliki budget
    _budgets.forEach((category, limit) {
      double spending = getCategorySpending(category);
      double threshold = limit * WARNING_THRESHOLD;
      
      if (spending >= limit) {
        // Melebihi limit (100%)
        print('🔴 OVER BUDGET: $category. Pengeluaran: Rp${spending.toStringAsFixed(2)} (Limit: Rp${limit.toStringAsFixed(2)})');
        hasAlert = true;
      } else if (spending >= threshold) {
        // Mendekati limit (>= 80%)
        double percent = (spending / limit) * 100;
        print('🟡 PERINGATAN: $category telah mencapai ${percent.toStringAsFixed(1)}% dari limit (Rp${limit.toStringAsFixed(2)})');
        hasAlert = true;
      }
    });

    if (!hasAlert) {
        print('Hijau ✅: Semua budget masih dalam batas aman.');
    }
  }

  // === 4. LAPORAN BUDGET ===
  void generateBudgetReport() {
    print('\n═══════════════════════════════════');
    print('📝 LAPORAN BUDGET BULANAN');
    print('═══════════════════════════════════');

    // Dapatkan semua kategori dari ExpenseManager untuk inklusifitas
    Set<String> allCategories = _budgets.keys.toSet();
    allCategories.addAll(expenseManager.getAllCategories());

    if (allCategories.isEmpty) {
        print('Tidak ada data budget maupun pengeluaran.');
        return;
    }

    // Urutkan kategori yang dilaporkan
    var sortedCategories = allCategories.toList()..sort();
    
    for (var category in sortedCategories) {
      double limit = _budgets[category] ?? 0.0;
      double spending = getCategorySpending(category);
      double remaining = limit - spending;
      
      String status;
      if (limit == 0 && spending > 0) {
        status = 'Tidak Berbudget';
      } else if (remaining < 0) {
        status = 'OVER BUDGET ❌';
      } else if (remaining == limit) {
        status = 'Belum Ada Pengeluaran';
      } else if (remaining <= limit * (1 - WARNING_THRESHOLD)) {
        status = 'AMAN ✅';
      } else {
        status = 'WASPADAI 🟡';
      }
      
      print('\nKATEGORI: $category');
      print('  Limit: Rp${limit.toStringAsFixed(2)}');
      print('  Keluar: Rp${spending.toStringAsFixed(2)}');
      print('  Sisa: Rp${remaining.toStringAsFixed(2)}');
      print('  Status: $status');
    }
    print('═══════════════════════════════════');
  }
}

// --- DEFINISI ULANG UNTUK PENGUJIAN ---

class Expense {
  final String description;
  final double amount;
  final String category;
  Expense({required this.description, required this.amount, required this.category});
}

// ExpenseManager sederhana untuk pengujian
class ExpenseManagerForTest extends ExpenseManager {
  final List<Expense> _expenses = [];

  void addExpense(Expense expense) => _expenses.add(expense);
  
  @override
  double getTotalByCategory(String category) {
    // Menggunakan fold untuk menghitung total
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
  
  @override
  List<String> getAllCategories() {
    return _expenses.map((e) => e.category).toSet().toList();
  }
}

// =================================================================
// --- MAIN PROGRAM (PENGUJIAN BUDGET) ---
// =================================================================
void main() {
  // 1. Setup ExpenseManager dan data
  var expenseManager = ExpenseManagerForTest();
  
  // Data pengeluaran
  expenseManager.addExpense(Expense(description: 'Gaji', amount: 350.0, category: 'Food'));
  expenseManager.addExpense(Expense(description: 'Bensin', amount: 150.0, category: 'Transport'));
  expenseManager.addExpense(Expense(description: 'Listrik', amount: 200.0, category: 'Bills'));
  expenseManager.addExpense(Expense(description: 'Dinner', amount: 250.0, category: 'Food'));
  expenseManager.addExpense(Expense(description: 'Tiket', amount: 50.0, category: 'Hiburan'));
  expenseManager.addExpense(Expense(description: 'Pulsa', amount: 80.0, category: 'Bills')); // Bills total: 280

  // 2. Setup BudgetManager
  var budgetManager = BudgetManager(expenseManager);
  
  // 3. Set Limit Budget
  budgetManager.setBudget('Food', 500.0);    // Pengeluaran 600.0 -> OVER BUDGET
  budgetManager.setBudget('Transport', 200.0); // Pengeluaran 150.0 -> AMAN (75%)
  budgetManager.setBudget('Bills', 300.0);   // Pengeluaran 280.0 -> WASPADA (93%)
  budgetManager.setBudget('Hiburan', 500.0); // Pengeluaran 50.0 -> AMAN

  // 4. Cek dan Tampilkan Alert
  budgetManager.checkAlerts();
  
  // 5. Generate Laporan Budget
  budgetManager.generateBudgetReport();
}