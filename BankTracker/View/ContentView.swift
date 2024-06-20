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
                        Text("Amount: \(debt.amount, specifier: "%.2f")")
                            .font(.subheadline)
                        Text("Due in \(viewModel.daysUntilDue(for: debt)) days")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: viewModel.removeDebt)
            }
            .navigationTitle("Debts")
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
