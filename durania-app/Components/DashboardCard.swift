import SwiftUI

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(color)
                    .cornerRadius(10)
                
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
}

#Preview {
    DashboardCard(
        title: "Bovinos",
        value: "120",
        icon: "hare.fill",
        color: .green
    )
}
