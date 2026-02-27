import SwiftUI

struct CowCard: View {
    let cow: CowLocation
    
    var body: some View {
        HStack {
            
            Circle()
                .fill(cow.status == .moving ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: cow.status == .moving ? "location.fill" : "pause.fill")
                        .foregroundColor(cow.status == .moving ? .green : .red)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cow.name)
                    .font(.headline)
                
                Text(cow.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Última señal")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text(cow.lastUpdate)
                    .font(.caption)
                    .bold()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}
