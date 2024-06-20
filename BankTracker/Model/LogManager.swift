import Foundation

class LogManager: ObservableObject {
    @Published var logs: [String] = []
    
    static let shared = LogManager()
    
    private init() {}

    func addLog(_ log: String) {
        logs.append(log)
        print(log)
    }

    func clearLogs() {
        logs.removeAll()
    }
}
