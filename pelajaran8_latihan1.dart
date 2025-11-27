import 'dart:core';

// =================================================================
// --- CLASS LEVEL 1: PaymentMethod (Superclass Abstrak) ---
// Class induk untuk semua metode pembayaran.
// Harus ada agar Cryptocurrency dapat meng-extend dan meng-override method.
// =================================================================
abstract class PaymentMethod {
  String get name;
  String get icon;
  
  // Method yang harus diimplementasikan oleh subclass
  bool validate();
  void processPayment(double amount);
  
  // Method bantu
  void showReceipt(double amount) {
    print('-----------------------------------------');
    print('✅ Pembayaran Sukses!');
    print('Metode: $name');
    print('Jumlah: Rp${amount.toStringAsFixed(2)}');
    print('-----------------------------------------');
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS LEVEL 2: Cryptocurrency (Subclass) ---
// (Kode Anda)
// =================================================================
class Cryptocurrency extends PaymentMethod {
  final String walletAddress;
  final String coinType;

  Cryptocurrency({
    required this.walletAddress,
    required this.coinType,
  });

  @override
  String get name => 'Dompet $coinType';

  @override
  String get icon => '₿'; // Ikon koin

  @override
  bool validate() {
    // Validasi wallet address tidak kosong dan minimal 20 karakter
    return walletAddress.isNotEmpty && walletAddress.length > 20;
  }

  @override
  void processPayment(double amount) {
    if (!validate()) {
      print('❌ Alamat wallet tidak valid untuk $coinType.');
      return;
    }

    print('$icon Memproses pembayaran $coinType...');
    // Menampilkan potongan awal dan akhir wallet
    print('Wallet: ${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}');
    print('⏳ Menunggu konfirmasi blockchain (beberapa menit)...');
    
    // Simulasikan delay dan cetak resi
    showReceipt(amount);
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CLASS LEVEL PENDUKUNG: Expense ---
// Harus ada agar main() dapat memanggil expense.payWith(btc).
// Diambil dari implementasi Expense sebelumnya.
// =================================================================
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  
  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  // Method yang digunakan di main()
  void payWith(PaymentMethod method) {
    print('\n=========================================');
    print('💵 MELAKUKAN PEMBAYARAN: ${description}');
    print('Jumlah: Rp${amount.toStringAsFixed(2)}');
    print('Menggunakan: ${method.name}');
    print('=========================================');
    
    // Delegasikan proses pembayaran ke metode yang spesifik
    method.processPayment(amount);
  }
}
// -----------------------------------------------------------------


// =================================================================
// --- CONTOH PENGGUNAAN (main) ---
// =================================================================
void main() {
  // 1. Inisiasi Metode Pembayaran
  var btc = Cryptocurrency(
    walletAddress: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa', // Contoh BTC address
    coinType: 'Bitcoin',
  );
  
  // Contoh dengan address yang tidak valid
  var ethInvalid = Cryptocurrency(
    walletAddress: '0x123', 
    coinType: 'Ethereum',
  );

  // 2. Inisiasi Expense
  var expense1 = Expense(
    description: 'Pembelian online',
    amount: 2500000.0,
    category: 'Belanja',
  );
  
  var expense2 = Expense(
    description: 'Biaya hosting server',
    amount: 500000.0,
    category: 'Bisnis',
  );

  // 3. Proses Pembayaran
  expense1.payWith(btc);

  print('\n*****************************************\n');

  // Uji validasi yang gagal
  expense2.payWith(ethInvalid);
}