import SwiftUI

struct BovineDetailView: View {
    
    let bovine: Bovine
    let vaccines: [Vaccine]
    let events: [HealthEvent]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                headerSection
                
                statusSection
                
                infoSection
                
                vaccinesSection
                
                eventsSection
            }
            .padding()
        }
        .navigationTitle("Detalle Bovino")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - UI Sections
    
    var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "hare.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text(bovine.earTag)
                .font(.title2)
                .bold()
            
            Text(bovine.breed)
                .foregroundColor(.gray)
        }
    }
    
    var statusSection: some View {
        HStack {
            Text("Estado sanitario")
                .font(.headline)
            
            Spacer()
            
            Text(bovine.healthStatus.rawValue)
                .font(.caption)
                .padding(8)
                .background(statusColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    var infoSection: some View {
        VStack(spacing: 12) {
            InfoRow(title: "Edad", value: "\(bovine.age) años")
            InfoRow(title: "Sexo", value: bovine.sex)
            InfoRow(title: "Peso", value: "\(Int(bovine.weight)) kg")
            InfoRow(title: "Rancho", value: bovine.ranch)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    var vaccinesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vacunas")
                .font(.headline)
            
            ForEach(vaccines) { vaccine in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(vaccine.name)
                            .bold()
                        Spacer()
                        Text(vaccine.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Dosis: \(vaccine.dose)")
                        .font(.caption)
                    
                    if let next = vaccine.nextDose {
                        Text("Próxima: \(next.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(14)
            }
        }
    }
    
    var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Eventos sanitarios")
                .font(.headline)
            
            ForEach(events) { event in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(event.title)
                            .bold()
                        Spacer()
                        Text(event.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(event.description)
                        .font(.caption)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(14)
            }
        }
    }
    
    var statusColor: Color {
        switch bovine.healthStatus {
        case .healthy: return .green
        case .observation: return .orange
        case .quarantine: return .red
        }
    }
}

#Preview {
    let sample = Bovine(
        id: UUID(),
        earTag: "MX-20394",
        name: nil,
        age: 2,
        breed: "Angus",
        sex: "Macho",
        weight: 430,
        healthStatus: .healthy,
        lastVaccine: Date(),
        ranch: "Rancho El Roble"
    )
    
    let vaccines = [
        Vaccine(id: UUID(), name: "Brucelosis", dose: "1ra", date: Date(), batch: "BRX-22", nextDose: nil),
        Vaccine(id: UUID(), name: "Tuberculosis", dose: "Refuerzo", date: Date().addingTimeInterval(-86400*90), batch: "TBC-10", nextDose: Date().addingTimeInterval(86400*60))
    ]
    
    let events = [
        HealthEvent(id: UUID(), title: "Revisión médica", description: "Chequeo general", date: Date()),
        HealthEvent(id: UUID(), title: "Tratamiento", description: "Antibiótico preventivo", date: Date().addingTimeInterval(-86400*20))
    ]
    
    return NavigationStack {
        BovineDetailView(bovine: sample, vaccines: vaccines, events: events)
    }
}
