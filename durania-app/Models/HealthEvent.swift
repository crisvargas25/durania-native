import Foundation

struct HealthEvent: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
}
