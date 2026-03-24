import SwiftUI

struct CowCard: View {
    let cow: CowLocation
    let isSelected: Bool
    let onTap: () -> Void
    let onDetailTap: () -> Void
    
    var body: some View {
        HStack {
            
            Circle()
                .fill(cow.status == .moving ? AppColors.successBg : AppColors.errorBg)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: cow.status == .moving ? "location.fill" : "pause.fill")
                        .foregroundColor(cow.status == .moving ? AppColors.successFg : AppColors.errorFg)
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

                Button(action: onDetailTap) {
                    Label("Detalle", systemImage: "chevron.right.circle.fill")
                        .font(.caption2.weight(.semibold))
                        .labelStyle(.titleAndIcon)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(AppColors.successBg)
                        .foregroundColor(AppColors.forestGreen)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? AppColors.tealGreen : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .contentShape(RoundedRectangle(cornerRadius: 14))
        .onTapGesture(perform: onTap)
    }
}
