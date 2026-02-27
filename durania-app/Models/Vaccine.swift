import Foundation

struct Vaccine: Identifiable {
    let id: UUID
    let name: String
    let dose: String
    let date: Date
    let batch: String
    let nextDose: Date?
}
