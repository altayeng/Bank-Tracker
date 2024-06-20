import Foundation

struct Debt: Identifiable, Codable {
    let id: UUID
    var name: String
    var bankName: String
    var amount: Double
    var dueDate: Date

    init(id: UUID = UUID(), name: String, bankName: String, amount: Double, dueDate: Date) {
        self.id = id
        self.name = name
        self.bankName = bankName
        self.amount = amount
        self.dueDate = dueDate
    }
}
