class Expense {
  final String description;
  final double amount;
  final String? frequency; // Digunakan untuk recurring expense

  // Constructor Biasa (Default/Positional)
  Expense(this.description, this.amount, {this.frequency});

  // 1. Named Constructor: Expense.splitBill
  // Digunakan untuk menghitung biaya per orang.
  Expense.splitBill(String description, double totalAmount, int numberOfPeople)
      : this.description = '$description (Split Bill)',
        this.amount = totalAmount / numberOfPeople,
        this.frequency = null; // Tidak ada frekuensi untuk biaya satu kali

  // 2. Named Constructor: Expense.tip
  // Digunakan untuk menghitung total biaya termasuk tip.
  Expense.tip(String description, double baseAmount, double tipPercent)
      : this.description = '$description (Include Tip)',
        this.amount = baseAmount * (1 + (tipPercent / 100)), // Hitung total: base + (base * tip%)
        this.frequency = null;

  // 3. Named Constructor: Expense.recurring
  // Digunakan untuk biaya berulang dengan frekuensi tertentu.
  Expense.recurring(this.description, this.amount, String frequency)
      : this.frequency = (['weekly', 'monthly', 'yearly'].contains(frequency.toLowerCase()) ? frequency.toLowerCase() : 'unknown');

  @override
  String toString() {
    String freqText = frequency != null && frequency != 'unknown' ? ' (Freq: $frequency)' : '';
    return 'Deskripsi: $description\n  Jumlah: ${amount.toStringAsFixed(2)}$freqText';
  }
}

void main() {
  print('--- 1. Expense.splitBill ---');
  // Biaya makan malam 150.000 dibagi 3 orang.
  var splitExpense = Expense.splitBill('Dinner', 150000.0, 3);
  print(splitExpense.toString());
  // Hasil: Jumlah per orang adalah 50000.00

  print('\n--- 2. Expense.tip ---');
  // Biaya layanan 200.000 dengan tip 15%.
  var tipExpense = Expense.tip('Service', 200000.0, 15.0);
  print(tipExpense.toString());
  // Hasil: Total biaya adalah 200000 * 1.15 = 230000.00

  print('\n--- 3. Expense.recurring ---');
  // Biaya langganan bulanan 50.000.
  var monthlyExpense = Expense.recurring('Subscription Fee', 50000.0, 'monthly');
  print(monthlyExpense.toString());
}