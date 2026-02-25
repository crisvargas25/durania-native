import SwiftUI

struct CattleListView: View {
    
    let cattleList: [Cattle] = [
        Cattle(tag: "MX-20394", age: "2 años", status: "Sano"),
        Cattle(tag: "MX-20395", age: "1.5 años", status: "Observación"),
        Cattle(tag: "MX-20396", age: "3 años", status: "Cuarentena"),
        Cattle(tag: "MX-20397", age: "1 año", status: "Sano")
    ]
    
    var body: some View {
        NavigationStack {
            List(cattleList) { cow in
                
                let bovine = mapToBovine(cow)
                
                NavigationLink {
                    BovineDetailView(
                        bovine: bovine,
                        vaccines: sampleVaccines,
                        events: sampleEvents
                    )
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(cow.tag)
                                .font(.headline)
                            
                            Text(cow.age)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(cow.status)
                            .font(.caption)
                            .padding(6)
                            .background(statusColor(cow.status))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Bovinos")
        }
    }
    
    // MARK: - Mapping
    
    func mapToBovine(_ cow: Cattle) -> Bovine {
        Bovine(
            id: UUID(),
            earTag: cow.tag,
            name: nil,
            age: Int(cow.age.prefix(1)) ?? 2,
            breed: "Angus",
            sex: "Macho",
            weight: 420,
            healthStatus: cow.status == "Sano"
                ? .healthy
                : cow.status == "Observación"
                    ? .observation
                    : .quarantine,
            lastVaccine: Date(),
            ranch: "Rancho El Roble"
        )
    }
    
    // MARK: - Sample Data
    
    let sampleVaccines: [Vaccine] = [
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
    
    let sampleEvents: [HealthEvent] = [
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
    
    // MARK: - Helpers
    
    func statusColor(_ status: String) -> Color {
        switch status {
        case "Sano": return .green
        case "Observación": return .orange
        case "Cuarentena": return .red
        default: return .gray
        }
    }
}

#Preview {
    CattleListView()
}
