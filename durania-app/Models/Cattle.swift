import Foundation

struct Cattle: Identifiable {
    let id = UUID()
    let tag: String      // Arete
    let age: String     // Edad visual
    let status: String  // Estado sanitario
}
