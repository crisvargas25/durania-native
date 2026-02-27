import SwiftUI

struct CattleListView: View {
    
    @State private var searchText = ""
    @State private var showAddModal = false
    
    let cattleList: [Cattle] = [
        Cattle(tag: "MX-20394", age: "2 años", status: "Sano"),
        Cattle(tag: "MX-20395", age: "1.5 años", status: "Observación"),
        Cattle(tag: "MX-20396", age: "3 años", status: "Cuarentena"),
        Cattle(tag: "MX-20397", age: "1 año", status: "Sano")
    ]
    
    var filteredCattle: [Cattle] {
        if searchText.isEmpty { return cattleList }
        return cattleList.filter {
            $0.tag.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(filteredCattle) { cow in
                        
                        let bovine = mapToBovine(cow)
                        
                        NavigationLink {
                            BovineDetailView(
                                bovine: bovine,
                                vaccines: sampleVaccines,
                                events: sampleEvents
                            )
                        } label: {
                            cattleCard(cow)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color.white)
            .navigationTitle("Ganado")
            .searchable(text: $searchText, prompt: "Buscar arete")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddModal.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.tealGreen)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddModal) {
                AddCattleView()
            }
        }
    }
    
    // MARK: - Card
    
    func cattleCard(_ cow: Cattle) -> some View {
        HStack(spacing: 14) {
            
            Circle()
                .fill(statusColor(cow.status))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cow.tag)
                    .font(.headline)
                    .foregroundColor(AppColors.forestGreen)
                
                Text("Edad: \(cow.age)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(cow.status)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor(cow.status).opacity(0.15))
                .foregroundColor(statusColor(cow.status))
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
    
    // MARK: - Helpers
    
    func statusColor(_ status: String) -> Color {
        switch status {
        case "Sano": return AppColors.tealGreen
        case "Observación": return .orange
        case "Cuarentena": return .red
        default: return .gray
        }
    }
    
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
}

#Preview {
    CattleListView()
}
