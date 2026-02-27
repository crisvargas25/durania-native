import Foundation

struct Bovine: Identifiable, Hashable {
    let id: UUID
    let earTag: String
    let name: String?
    let age: Int
    let breed: String
    let sex: String
    let weight: Double
    let healthStatus: HealthStatus
    let lastVaccine: Date?
    let ranch: String

    // Hashable & Equatable based on stable identity
    static func == (lhs: Bovine, rhs: Bovine) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum HealthStatus: String, CaseIterable {
    case healthy = "Sano"
    case observation = "Observación"
    case quarantine = "Cuarentena"
}
