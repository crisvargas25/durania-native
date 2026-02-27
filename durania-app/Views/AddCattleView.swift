import SwiftUI

struct AddCattleView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var tag = ""
    @State private var age = ""
    @State private var breed = ""
    @State private var sex = "Macho"
    @State private var weight = ""
    
    let sexes = ["Macho", "Hembra"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Identificación") {
                    TextField("Arete", text: $tag)
                    TextField("Edad", text: $age)
                }
                
                Section("Datos generales") {
                    TextField("Raza", text: $breed)
                    
                    Picker("Sexo", selection: $sex) {
                        ForEach(sexes, id: \.self) { s in
                            Text(s)
                        }
                    }
                    
                    TextField("Peso (kg)", text: $weight)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Nuevo Bovino")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.tealGreen)
                }
            }
        }
    }
}

#Preview {
    AddCattleView()
}
