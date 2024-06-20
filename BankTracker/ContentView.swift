import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = DebtViewModel()
    @State private var showingAddDebt = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.debts) { debt in
                    VStack(alignment: .leading) {
                        Text(debt.name)
                            .font(.headline)
                        Text(debt.bankName)
                            .font(.subheadline)
                        Text("Borç: \(debt.amount, specifier: "%.2f")")
                            .font(.subheadline)
                        Text("Son ödeme: \(viewModel.daysUntilDue(for: debt)) gün sonra.")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: viewModel.removeDebt)
            }
            .navigationTitle("Borçlar")
            
            
            
            .navigationBarItems(trailing: Button(action: {
                showingAddDebt = true
            }) {
                Image(systemName: "plus")
            })
             
            .sheet(isPresented: $showingAddDebt) {
                AddDebtView(viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
