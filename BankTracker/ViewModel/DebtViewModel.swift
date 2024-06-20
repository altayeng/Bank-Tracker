import SwiftUI
import UserNotifications

class DebtViewModel: ObservableObject {
    @Published var debts: [Debt] = [] {
        didSet {
            saveDebts()
        }
    }

    private let debtsKey = "debts"

    init() {
        loadDebts()
    }

    func addDebt(name: String, bankName: String, amount: Double, dueDate: Date) {
        let newDebt = Debt(name: name, bankName: bankName, amount: amount, dueDate: dueDate)
        debts.append(newDebt)
        scheduleNotifications(for: newDebt)
        scheduleImmediateNotification(for: newDebt)
    }

    func removeDebt(at offsets: IndexSet) {
        debts.remove(atOffsets: offsets)
    }

    func daysUntilDue(for debt: Debt) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: debt.dueDate)
        return components.day ?? 0
    }

    private func saveDebts() {
        if let encoded = try? JSONEncoder().encode(debts) {
            UserDefaults.standard.set(encoded, forKey: debtsKey)
        }
    }

    private func loadDebts() {
        if let savedDebts = UserDefaults.standard.data(forKey: debtsKey),
           let decodedDebts = try? JSONDecoder().decode([Debt].self, from: savedDebts) {
            debts = decodedDebts
        }
    }

    private func scheduleNotifications(for debt: Debt) {
        let calendar = Calendar.current
        let notificationCenter = UNUserNotificationCenter.current()

        for day in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Borç Hatırlatma"
            content.body = "\(debt.name) borcunuzun son ödeme tarihi yaklaşıyor!"
            content.sound = UNNotificationSound.default

            if let triggerDate = calendar.date(byAdding: .day, value: -day, to: debt.dueDate) {
                let triggerDateComponents = calendar.dateComponents([.year, .month, .day], from: triggerDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

                let request = UNNotificationRequest(identifier: "\(debt.id)-\(day)", content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func scheduleImmediateNotification(for debt: Debt) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Borç Eklendi"
        content.body = "\(debt.name) borcunuz başarıyla eklendi."
        content.sound = UNNotificationSound.default
        print("bildirim eklendi")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "\(debt.id)-immediate", content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("Anlık bildirim eklenirken hata oluştu: \(error.localizedDescription)")
            }
        }
    }
}
