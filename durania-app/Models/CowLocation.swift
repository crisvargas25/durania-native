import Foundation
import CoreLocation

struct CowLocation: Identifiable, Hashable {
    let id: UUID
    let earTag: String
    let name: String
    let latitude: Double
    let longitude: Double
    let status: CowStatus
    let lastUpdate: String

    init(
        id: UUID = UUID(),
        earTag: String,
        name: String,
        latitude: Double,
        longitude: Double,
        status: CowStatus,
        lastUpdate: String
    ) {
        self.id = id
        self.earTag = earTag
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.lastUpdate = lastUpdate
    }
}

enum CowStatus: String {
    case moving = "En movimiento"
    case stopped = "Detenida"
}
