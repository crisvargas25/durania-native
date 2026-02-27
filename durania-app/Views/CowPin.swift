import SwiftUI

struct CowPin: View {
    
    let cow: CowLocation
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(cow.status == .moving ? .green : .red)
            
            Text(cow.name)
                .font(.caption2)
                .bold()
                .padding(4)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
        }
    }
}   
