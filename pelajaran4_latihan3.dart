class BankAccount {
  // 1. Private Properties
  final String _accountHolder;
  double _balance;
  int _pin;

  // Constructor untuk inisialisasi awal
  BankAccount(this._accountHolder, this._pin, [this._balance = 0.0]);

  // 2. Getter untuk balance (hanya baca, tanpa setter)
  double get balance => _balance;

  // --- Metode Transaksi ---

  // 3. Method: deposit(amount)
  // Tidak bisa deposit jumlah negatif
  String deposit(double amount) {
    if (amount <= 0) {
      return '❌ Deposit Gagal: Jumlah deposit harus positif.';
    }
    _balance += amount;
    return '✅ Deposit Berhasil: Rp ${amount.toStringAsFixed(2)}. Saldo baru: Rp ${_balance.toStringAsFixed(2)}.';
  }

  // 4. Method: withdraw(amount, pin)
  // Tidak bisa withdraw tanpa PIN yang benar
  // Tidak bisa withdraw lebih dari saldo
  String withdraw(double amount, int pin) {
    // Validasi 1: Cek PIN
    if (pin != _pin) {
      return '❌ Withdrawal Gagal: PIN salah.';
    }

    // Validasi 2: Cek jumlah
    if (amount <= 0) {
      return '❌ Withdrawal Gagal: Jumlah penarikan harus positif.';
    }

    // Validasi 3: Cek saldo
    if (amount > _balance) {
      return '❌ Withdrawal Gagal: Saldo tidak mencukupi (Rp ${amount.toStringAsFixed(2)} > Rp ${_balance.toStringAsFixed(2)}).';
    }

    // Transaksi berhasil
    _balance -= amount;
    return '✅ Withdrawal Berhasil: Rp ${amount.toStringAsFixed(2)}. Saldo baru: Rp ${_balance.toStringAsFixed(2)}.';
  }

  // 5. Method: changePin(oldPin, newPin)
  String changePin(int oldPin, int newPin) {
    if (oldPin != _pin) {
      return '❌ Ganti PIN Gagal: PIN lama salah.';
    }
    if (newPin.toString().length != 4) { // Contoh validasi sederhana
      return '❌ Ganti PIN Gagal: PIN baru harus 4 digit.';
    }

    _pin = newPin;
    return '✅ Ganti PIN Berhasil.';
  }

  @override
  String toString() {
    return 'Rekening ${_accountHolder}\n  Saldo Saat Ini: Rp ${_balance.toStringAsFixed(2)}';
  }
}

void main() {
  // Inisialisasi Rekening dengan saldo awal 1,000,000
  var account = BankAccount('Rina Setiawati', 1234, 1000000.0);
  print('--- Status Awal ---');
  print(account);
  print('Akses Saldo via Getter: Rp ${account.balance.toStringAsFixed(2)}');
  
  print('\n--- Uji Deposit ---');
  print(account.deposit(500000.0)); // Sukses
  print(account.deposit(-100.0));   // Gagal (negatif)

  print('\n--- Uji Withdrawal Gagal ---');
  print(account.withdraw(2000000.0, 1234)); // Gagal (saldo tidak cukup)
  print(account.withdraw(100000.0, 9999));  // Gagal (PIN salah)

  print('\n--- Uji Withdrawal Sukses ---');
  print(account.withdraw(500000.0, 1234)); // Sukses
  print(account);

  print('\n--- Uji Ganti PIN ---');
  print(account.changePin(9999, 4321));  // Gagal (PIN lama salah)
  print(account.changePin(1234, 4321));  // Sukses
  
  // Uji withdrawal dengan PIN baru
  print(account.withdraw(100000.0, 4321)); 
}