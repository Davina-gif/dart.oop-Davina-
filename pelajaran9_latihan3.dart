class User {
  final String userId;
  final String username;
  String email;
  String currency;

  User({
    required this.userId,
    required this.username,
    required this.email,
    this.currency = 'Rp',
  });

  void updateProfile({String? newEmail, String? newCurrency}) {
    if (newEmail != null) this.email = newEmail;
    if (newCurrency != null) this.currency = newCurrency;
    print('✏️ Profil ${username} diupdate. Mata uang: $currency.');
  }
  
  // Method untuk menampilkan ringkasan profil
  void printProfile() {
    print('👤 Profil Pengguna: ${username}');
    print('  ID: $userId');
    print('  Email: $email');
    print('  Mata Uang Default: $currency');
  }
}

// Import ExpenseManager dari bagian sebelumnya (dianggap sudah ada)
// class ExpenseManager { List<Expense> _expenses = []; ... }
// class Expense { ... }

class MultiUserManager {
  // Map<UserID, User> untuk menyimpan data profil
  final Map<String, User> _userProfiles = {};
  
  // Map<UserID, ExpenseManager> untuk menyimpan data pengeluaran terpisah
  final Map<String, ExpenseManager> _userExpenseManagers = {}; 

  String? _currentUserId; // Melacak user yang sedang login

  // === 1. DAFTAR USER ===
  void registerUser(String userId, String username, String email) {
    if (_userProfiles.containsKey(userId)) {
      print('❌ Pendaftaran gagal: User ID "$userId" sudah terdaftar.');
      return;
    }
    
    // Buat profil user baru
    final newUser = User(userId: userId, username: username, email: email);
    _userProfiles[userId] = newUser;
    
    // Buat ExpenseManager baru yang kosong untuk user ini
    _userExpenseManagers[userId] = ExpenseManager(); 
    
    print('🎉 Pendaftaran sukses! Selamat datang, ${username}.');
  }

  // === 2. LOGIN USER ===
  bool login(String userId) {
    if (!_userProfiles.containsKey(userId)) {
      print('❌ Login gagal: User ID "$userId" tidak ditemukan.');
      _currentUserId = null;
      return false;
    }
    
    _currentUserId = userId;
    print('🔓 Login sukses sebagai: ${_userProfiles[userId]!.username}.');
    return true;
  }
  
  // === 3. LOGOUT USER ===
  void logout() {
    if (_currentUserId != null) {
      print('🔒 Logout dari ${_userProfiles[_currentUserId!]!.username}.');
      _currentUserId = null;
    } else {
      print('Belum ada user yang login.');
    }
  }

  // === 4. AKSES MANAGER & PROFIL ===
  
  // Mendapatkan ExpenseManager dari user yang sedang login
  ExpenseManager? getCurrentExpenseManager() {
    if (_currentUserId == null) {
      print('❌ Error: Tidak ada user yang login.');
      return null;
    }
    return _userExpenseManagers[_currentUserId!];
  }
  
  // Mendapatkan Profil dari user yang sedang login
  User? getCurrentUserProfile() {
    if (_currentUserId == null) {
      print('❌ Error: Tidak ada user yang login.');
      return null;
    }
    return _userProfiles[_currentUserId!];
  }
  
  // Debug: Tampilkan daftar semua user
  void printAllUsers() {
    print('\n--- DAFTAR SEMUA USER (${_userProfiles.length}) ---');
    _userProfiles.forEach((id, user) {
      print('ID: $id | Nama: ${user.username} | Pengeluaran: ${_userExpenseManagers[id]!.getCount()}');
    });
  }
}

// --- SIMULASI CLASS PENDUKUNG ---

class Expense {
  final String description;
  final double amount;
  final String category;
  Expense({required this.description, required this.amount, required this.category});
}

class ExpenseManager {
  List<Expense> _expenses = [];
  
  void addExpense(Expense expense) => _expenses.add(expense);
  int getCount() => _expenses.length;
  double getTotalSpending() => _expenses.fold(0.0, (sum, e) => sum + e.amount);
}
// ---------------------------------

void main() {
  var userManager = MultiUserManager();

  // 1. Pendaftaran
  userManager.registerUser('user1', 'Alice', 'alice@email.com');
  userManager.registerUser('user2', 'Bob', 'bob@email.com');

  // 2. Login Alice
  userManager.login('user1');
  var aliceManager = userManager.getCurrentExpenseManager();
  
  // Alice menambahkan pengeluaran
  aliceManager?.addExpense(Expense(description: 'Lunch', amount: 50.0, category: 'Food'));
  aliceManager?.addExpense(Expense(description: 'Film', amount: 120.0, category: 'Hiburan'));
  
  print('Total pengeluaran Alice: ${aliceManager?.getTotalSpending()}');
  
  // Alice mengupdate profil
  userManager.getCurrentUserProfile()?.updateProfile(newCurrency: 'USD');

  // 3. Logout dan Login Bob
  userManager.logout();
  userManager.login('user2');
  var bobManager = userManager.getCurrentExpenseManager();

  // Bob menambahkan pengeluaran
  bobManager?.addExpense(Expense(description: 'Bensin', amount: 80.0, category: 'Transport'));
  
  print('Total pengeluaran Bob: ${bobManager?.getTotalSpending()}');
  
  // Bob melihat profil Alice (tidak bisa, hanya profilnya sendiri)
  userManager.getCurrentUserProfile()?.printProfile(); 

  // 4. Lihat status akhir
  userManager.printAllUsers();
}