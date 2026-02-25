//
//  ProfileView.swift
//  duranative
//
//  Created by Cristian Vargas on 19/02/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            Section("Cuenta") {
                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(.blue)
                    VStack(alignment: .leading) {
                        Text("Usuario")
                            .font(.headline)
                        Text("usuario@ejemplo.com")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Preferencias") {
                Toggle("Notificaciones", isOn: .constant(true))
                Toggle("Modo oscuro", isOn: .constant(false))
            }

            Section {
                Button(role: .destructive) {
                    // Cerrar sesión action
                } label: {
                    Text("Cerrar sesión")
                }
            }
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
}

