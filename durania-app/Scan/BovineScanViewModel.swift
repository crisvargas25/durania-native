import Foundation
internal import Combine

@MainActor
final class BovineScanViewModel: ObservableObject {
    @Published var selectedBovine: Bovine?
    @Published var vaccines: [Vaccine] = []
    @Published var events: [HealthEvent] = []
    @Published var errorMessage: String?
    @Published var isScanningNFC = false

    private let nfcService: NFCServiceProtocol
    private let catalog: [String: Bovine]

    init(nfcService: NFCServiceProtocol) {
        self.nfcService = nfcService
        self.catalog = BovineScanViewModel.defaultCatalog()
    }

    @MainActor
    convenience init() {
        self.init(nfcService: NFCService())
    }

    func startNFCScan() {
        clearError()
        isScanningNFC = true

        nfcService.startSimulatedScan { [weak self] result in
            guard let self else { return }
            self.isScanningNFC = false

            switch result {
            case .success(let data):
                self.handleScan(rawValue: data.rawValue, source: data.source)
            case .failure:
                self.selectedBovine = nil
                self.errorMessage = "No se pudo completar el escaneo NFC."
            }
        }
    }

    func handleScan(rawValue: String, source: ScanSource) {
        _ = source
        clearError()

        guard let tag = extractEarTag(from: rawValue) else {
            selectedBovine = nil
            vaccines = []
            events = []
            errorMessage = "Código inválido"
            return
        }

        guard let bovine = catalog[tag] else {
            selectedBovine = nil
            vaccines = []
            events = []
            errorMessage = "Animal no encontrado"
            return
        }

        selectedBovine = bovine
        vaccines = Self.sampleVaccines
        events = Self.sampleEvents
    }

    func clearError() {
        errorMessage = nil
    }

    private func extractEarTag(from value: String) -> String? {
        let sanitized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitized.isEmpty else { return nil }

        if isValidEarTag(sanitized.uppercased()) {
            return sanitized.uppercased()
        }

        if let components = URLComponents(string: sanitized), !components.path.isEmpty {
            let segments = components.path
                .split(separator: "/")
                .map { String($0).uppercased() }

            if let firstValid = segments.first(where: { isValidEarTag($0) }) {
                return firstValid
            }
        }

        return nil
    }

    private func isValidEarTag(_ value: String) -> Bool {
        let pattern = #"^[A-Z]{2}-[0-9]{3,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }

    private static func defaultCatalog() -> [String: Bovine] {
        [
            "MX-20394": Bovine(
                id: UUID(),
                earTag: "MX-20394",
                name: "Luna",
                age: 2,
                breed: "Angus",
                sex: "Hembra",
                weight: 430,
                healthStatus: .healthy,
                lastVaccine: Date(),
                ranch: "Rancho El Roble"
            ),
            "MX-20395": Bovine(
                id: UUID(),
                earTag: "MX-20395",
                name: "Niebla",
                age: 1,
                breed: "Brahman",
                sex: "Hembra",
                weight: 390,
                healthStatus: .observation,
                lastVaccine: Date().addingTimeInterval(-86400 * 30),
                ranch: "Rancho El Roble"
            ),
            "MX-20396": Bovine(
                id: UUID(),
                earTag: "MX-20396",
                name: "Rayo",
                age: 3,
                breed: "Charolais",
                sex: "Macho",
                weight: 470,
                healthStatus: .quarantine,
                lastVaccine: Date().addingTimeInterval(-86400 * 60),
                ranch: "Rancho El Roble"
            ),
            "MX-20397": Bovine(
                id: UUID(),
                earTag: "MX-20397",
                name: "Brisa",
                age: 1,
                breed: "Angus",
                sex: "Hembra",
                weight: 360,
                healthStatus: .healthy,
                lastVaccine: Date().addingTimeInterval(-86400 * 15),
                ranch: "Rancho El Roble"
            )
        ]
    }

    private static let sampleVaccines: [Vaccine] = [
        Vaccine(
            id: UUID(),
            name: "Brucelosis",
            dose: "1ra",
            date: Date().addingTimeInterval(-86400 * 30),
            batch: "BRX-22",
            nextDose: Date().addingTimeInterval(86400 * 180)
        ),
        Vaccine(
            id: UUID(),
            name: "Tuberculosis",
            dose: "Refuerzo",
            date: Date().addingTimeInterval(-86400 * 90),
            batch: "TBC-10",
            nextDose: nil
        )
    ]

    private static let sampleEvents: [HealthEvent] = [
        HealthEvent(
            id: UUID(),
            title: "Revisión médica",
            description: "Chequeo general sin anomalías",
            date: Date().addingTimeInterval(-86400 * 7)
        ),
        HealthEvent(
            id: UUID(),
            title: "Desparasitación",
            description: "Tratamiento preventivo",
            date: Date().addingTimeInterval(-86400 * 60)
        )
    ]
}
