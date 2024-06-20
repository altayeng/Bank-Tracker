import SwiftUI

struct AddDebtView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DebtViewModel

    @State private var name = ""
    @State private var bankName = ""
    @State private var amount = ""
    @State private var dueDate = Date()
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Borç Türü", text: $name)
                TextField("Banka Adı", text: $bankName)
                TextField("Miktar", text: $amount)
                    .keyboardType(.decimalPad)
                DatePicker("Son Ödeme", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle("Borç Ekle")
            .navigationBarItems(leading: Button("Çıkış") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Kaydet") {
                if let amount = Double(amount) {
                    viewModel.addDebt(name: name, bankName: bankName, amount: amount, dueDate: dueDate)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showAlert = true
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Geçersiz Borç Miktarı"), message: Text("Borç miktarını sayı olarak giriniz."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddDebtView_Previews: PreviewProvider {
    static var previews: some View {
        AddDebtView(viewModel: DebtViewModel())
    }
}
