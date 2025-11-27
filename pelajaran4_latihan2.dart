class User {
  // 1. Private Properties
  String _name;
  String _email;
  int _age;

  // Constructor
  User(this._name, this._email, this._age) {
    // Memastikan properti divalidasi saat inisialisasi awal
    // Panggil setter untuk validasi email dan age.
    this.email = _email;
    this.age = _age;
  }

  // --- GETTERS (Akses Baca) ---

  String get name => _name;
  String get email => _email;
  int get age => _age;

  // --- SETTERS (Akses Tulis dengan Validasi) ---

  // Setter untuk name (Tidak ada validasi spesifik)
  set name(String newName) {
    _name = newName;
  }

  // Setter untuk email: Harus mengandung karakter '@'
  set email(String newEmail) {
    if (newEmail.contains('@')) {
      _email = newEmail;
    } else {
      throw FormatException('Error: Email harus mengandung karakter \'@\'.');
    }
  }

  // Setter untuk age: Harus antara 13 dan 120
  set age(int newAge) {
    if (newAge >= 13 && newAge <= 120) {
      _age = newAge;
    } else {
      throw RangeError('Error: Umur harus di antara 13 dan 120 tahun.');
    }
  }

  // --- COMPUTED GETTERS ---

  // Computed Getter 1: isAdult (age >= 18)
  bool get isAdult => _age >= 18;

  // Computed Getter 2: displayName (name + kategori usia)
  String get displayName {
    String category;

    if (_age < 18) {
      category = '(Remaja)';
    } else if (_age >= 18 && _age <= 60) {
      category = '(Dewasa)';
    } else {
      category = '(Lansia)';
    }

    return '$_name $category';
  }
}

void main() {
  // --- Contoh Penggunaan Sukses ---
  print('--- Penggunaan Sukses ---');
  try {
    var user1 = User('Anya Forger', 'anya@spy.com', 17);
    print('Nama Tampilan: ${user1.displayName}'); // Anya Forger (Remaja)
    print('Email: ${user1.email}');
    print('Apakah Dewasa? ${user1.isAdult}'); // false

    user1.age = 30; // Ubah umur menggunakan setter
    print('Nama Tampilan Baru: ${user1.displayName}'); // Anya Forger (Dewasa)
    print('Apakah Dewasa? ${user1.isAdult}'); // true

  } on Exception catch (e) {
    print('Terjadi Error: $e');
  }

  // --- Contoh Penggunaan Gagal (Validasi Email) ---
  print('\n--- Validasi Email Gagal ---');
  try {
    var user2 = User('Loid Forger', 'loid.spy', 35); // Email salah (tanpa @)
  } on Exception catch (e) {
    print('Terjadi Error: $e');
  }
  
  // --- Contoh Penggunaan Gagal (Validasi Umur) ---
  print('\n--- Validasi Umur Gagal ---');
  try {
    var user3 = User('Yor Forger', 'yor@assassin.com', 5); // Umur terlalu muda (<13)
  } on Exception catch (e) {
    print('Terjadi Error: $e');
  }
}