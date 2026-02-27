import SwiftUI
import RealityKit
import ARKit

// MARK: - Vista Principal AR

struct ARScanView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            // Vista AR
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            
            // Botón flotante volver
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Volver")
                        }
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 14)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Contenedor AR

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARImageTrackingConfiguration()
        
        guard let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "CodigosGanado",
            bundle: nil
        ) else {
            print("⚠️ No se encontraron imágenes AR")
            return arView
        }
        
        config.trackingImages = referenceImages
        config.maximumNumberOfTrackedImages = 1
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        context.coordinator.view = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator() }

    // MARK: - Coordinator
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor {
                    let nombreAnimal = imageAnchor.referenceImage.name ?? "Animal"
                    mostrarCartel(nombre: nombreAnimal, anchor: imageAnchor)
                }
            }
        }

        func mostrarCartel(nombre: String, anchor: ARImageAnchor) {
            guard let view = view else { return }

            let anchorEntity = AnchorEntity(anchor: anchor)

            let mesh = MeshResource.generateText(
                "ID: \(nombre)\nESTADO: ACTIVO",
                extrusionDepth: 0.01,
                font: .systemFont(ofSize: 0.03, weight: .bold),
                containerFrame: CGRect(
                    x: -0.25,
                    y: -0.1,
                    width: 0.5,
                    height: 0.2
                ),
                alignment: .center,
                lineBreakMode: .byWordWrapping
            )
            
            let material = SimpleMaterial(color: .white, isMetallic: false)
            let cartelEntity = ModelEntity(mesh: mesh, materials: [material])

            cartelEntity.orientation = simd_quatf(
                angle: -Float.pi / 2,
                axis: [1, 0, 0]
            )

            cartelEntity.position.y = 0.05

            anchorEntity.addChild(cartelEntity)
            view.scene.addAnchor(anchorEntity)
        }
    }
}
