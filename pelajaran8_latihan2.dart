import 'dart:core';

// =================================================================
// --- CLASS INDUK (SUPERCLASS): PaymentMethod ---
// Harus ada agar CreditCard dan Cash dapat meng-extend
// =================================================================
abstract class PaymentMethod {
  String get name;
  String get icon;
  
  // Method yang harus diimplementasikan oleh subclass
  void processPayment(double amount);
  
  // Method bantu
  void showReceipt(double amount) {
    print('-----------------------------------------');
    print('✅ Pembayaran Sukses!');
    print('Metode: $name');
    print('Jumlah: \$${amount.toStringAsFixed(2)}');
    print('-----------------------------------------');
  }
}

// =================================================================
// --- INTERFACE: Refundable ---
// Interface (abstract class) yang mendefinisikan kemampuan refund
// =================================================================
abstract class Refundable {
  bool canRefund();
  void processRefund(double amount);
}
// -----------------------------------------------------------------

// =================================================================
// --- SUBCLASS 1: CreditCard (implements Refundable) ---
// =================================================================
class CreditCard extends PaymentMethod implements Refundable {
  final String cardNumber;
  final String cardHolder;
  final List<double> transactions = [];

  CreditCard({
    required this.cardNumber,
    required this.cardHolder,
  });

  @override
  String get name => 'Kartu Kredit';

  @override
  String get icon => '💳';

  @override
  void processPayment(double amount) {
    // Validasi kartu
    if (cardNumber.length < 16) {
        print('❌ Kartu tidak valid.');
        return;
    }
    
    transactions.add(amount);
    print('$icon Mendebet \$${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }

  // --- Implementasi Refundable ---
  @override
  bool canRefund() {
    // Cek apakah ada transaksi positif yang bisa direfund (sederhana)
    return transactions.any((t) => t > 0); 
  }

  @override
  void processRefund(double amount) {
    if (!canRefund()) {
      print('❌ Tidak ada transaksi positif untuk direfund');
      return;
    }

    print('🔄 Memproses refund \$${amount.toStringAsFixed(2)} ke Kartu Kredit');
    print('   Refund akan muncul dalam 3-5 hari kerja');
    transactions.add(-amount); // Negatif untuk refund
  }
}

// =================================================================
// --- SUBCLASS 2: Cash (TIDAK implements Refundable) ---
// =================================================================
class Cash extends PaymentMethod {
  @override
  String get name => 'Tunai';

  @override
  String get icon => '💵';

  @override
  void processPayment(double amount) {
    print('$icon Pembayaran tunai: \$${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }
}
// -----------------------------------------------------------------

void main() {
  var card = CreditCard(
    cardNumber: '4532123456789012',
    cardHolder: 'John Doe',
  );
  var cash = Cash();

  print('--- Uji Pembayaran Kartu ---');
  card.processPayment(100.0);

  print('\n--- Uji Refund Kartu ---');
  // Cek type casting: card adalah PaymentMethod, tetapi juga Refundable
  if (card is Refundable) {
    // Casting 'card' ke type Refundable untuk memanggil methodnya
    (card as Refundable).processRefund(50.0);
  }

  print('\n--- Uji Pembayaran Tunai ---');
  cash.processPayment(50.0);

  print('\n--- Uji Refund Tunai ---');
  // Cek type casting: cash adalah PaymentMethod, tetapi BUKAN Refundable
  if (cash is Refundable) {
    (cash as Refundable).processRefund(25.0);
  } else {
    print('❌ Pembayaran tunai (${cash.name}) tidak mengimplementasikan interface Refundable.');
  }
  
  print('\n--- Saldo Transaksi Kartu ---');
  // Transaksi: [100.0, -50.0]. Saldo bersih 50.0
  double netBalance = card.transactions.fold(0.0, (sum, t) => sum + t);
  print('Total transaksi Kartu Kredit: ${card.transactions.length} | Saldo Bersih: \$${netBalance.toStringAsFixed(2)}');
}