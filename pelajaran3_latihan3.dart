class User {
  // Properties
  final String name;
  final String email;
  final String currency; // Mata uang default untuk budget (misalnya, USD, IDR)
  final double monthlyBudget;
  final bool notifications;

  // 1. Constructor Utama dengan Named Parameters
  User({
    required this.name,
    required this.email,
    required this.currency,
    required this.monthlyBudget,
    this.notifications = true,
  });

  // 2. Named Constructor: User.quick
  User.quick({required this.name, required this.email})
      : this.currency = 'USD',
        this.monthlyBudget = 2000.0,
        this.notifications = true; 

  // 3. Named Constructor: User.premium
  User.premium({
    required this.name,
    required this.email,
    required this.monthlyBudget,
  })  : this.currency = 'USD',
        this.notifications = true;

  @override
  String toString() {
    return '👤 User: $name ($email)\n'
        '  💰 Budget: ${currency} ${monthlyBudget.toStringAsFixed(2)}\n'
        '  🔔 Notifikasi: ${notifications ? "Aktif" : "Nonaktif"}';
  }
}

void main() {
  print('--- 1. Constructor Utama (Lengkap) ---');
  // Contoh 1: Menggunakan constructor utama (notifikasi disetel ke false)
  var fullUser = User(
    name: 'Budi Utama',
    email: 'budi@example.com',
    currency: 'IDR',
    monthlyBudget: 8000000.0,
    notifications: false,
  );
  print(fullUser.toString());

  print('\n--- 2. Named Constructor User.quick ---');
  // Contoh 2: User.quick (menggunakan default USD dan $2000)
  var quickUser = User.quick(
    name: 'Rina Cepat',
    email: 'rina@quick.com',
  );
  print(quickUser.toString());

  print('\n--- 3. Named Constructor User.premium ---');
  // Contoh 3: User.premium (menggunakan default USD, notifikasi on)
  var premiumUser = User.premium(
    name: 'Adi Premium',
    email: 'adi@premium.com',
    monthlyBudget: 5000.0,
  );
  print(premiumUser.toString());
}