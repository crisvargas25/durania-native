import SwiftUI
import RealityKit
import ARKit
import UIKit

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
    
    @MainActor
    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        private var posterEntitiesByAnchorID: [UUID: ModelEntity] = [:]
        private var anchorEntitiesByID: [UUID: AnchorEntity] = [:]
        private let visualConfig = PosterVisualConfig()

        private struct PosterVisualConfig {
            let width: Float = 0.22
            let height: Float = 0.12
            let cornerRadius: Float = 0.012
            let yOffset: Float = 0.10
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor {
                    upsertPoster(for: imageAnchor)
                }
            }
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                guard let imageAnchor = anchor as? ARImageAnchor else { continue }

                if posterEntitiesByAnchorID[imageAnchor.identifier] == nil {
                    upsertPoster(for: imageAnchor)
                }

                guard let currentFrame = session.currentFrame else { continue }
                updateBillboard(for: imageAnchor.identifier, frame: currentFrame)
            }
        }

        func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
            for anchor in anchors {
                let anchorID = anchor.identifier
                posterEntitiesByAnchorID.removeValue(forKey: anchorID)

                if let anchorEntity = anchorEntitiesByID.removeValue(forKey: anchorID) {
                    view?.scene.removeAnchor(anchorEntity)
                }
            }
        }

        private func upsertPoster(for imageAnchor: ARImageAnchor) {
            guard let view = view else { return }
            let anchorID = imageAnchor.identifier
            guard posterEntitiesByAnchorID[anchorID] == nil else { return }

            let anchorEntity = AnchorEntity(anchor: imageAnchor)
            let bovineID = imageAnchor.referenceImage.name ?? "MX-00000"
            let status = "ACTIVO"
            let action = "Acción: Monitoreo normal"

            let posterEntity = makePosterEntity(
                bovineID: bovineID,
                status: status,
                action: action
            )
            // Inicialmente en el origen del anchor; el offset real se aplica en mundo en updateBillboard.
            posterEntity.position = .zero

            anchorEntity.addChild(posterEntity)
            view.scene.addAnchor(anchorEntity)

            posterEntitiesByAnchorID[anchorID] = posterEntity
            anchorEntitiesByID[anchorID] = anchorEntity
        }

        private func makePosterEntity(bovineID: String, status: String, action: String) -> ModelEntity {
            let mesh = MeshResource.generatePlane(
                width: visualConfig.width,
                height: visualConfig.height,
                cornerRadius: visualConfig.cornerRadius
            )

            if let texture = makePosterTexture(for: bovineID, status: status, action: action) {
                let material = UnlitMaterial(texture: texture)
                return ModelEntity(mesh: mesh, materials: [material])
            }

            // Fallback seguro: panel simple + texto mínimo para no romper experiencia
            let fallbackMaterial = SimpleMaterial(
                color: UIColor(red: 0.1, green: 0.2, blue: 0.18, alpha: 0.9),
                isMetallic: false
            )
            let fallbackPanel = ModelEntity(mesh: mesh, materials: [fallbackMaterial])
            let textMesh = MeshResource.generateText(
                "\(bovineID)\n\(status)",
                extrusionDepth: 0.001,
                font: .systemFont(ofSize: 0.012, weight: .semibold),
                containerFrame: CGRect(x: -0.09, y: -0.03, width: 0.18, height: 0.06),
                alignment: .center,
                lineBreakMode: .byWordWrapping
            )
            let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
            let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
            textEntity.position = [0, 0, 0.0015]
            fallbackPanel.addChild(textEntity)
            return fallbackPanel
        }

        private func makePosterTexture(for id: String, status: String, action: String) -> TextureResource? {
            let size = CGSize(width: 1024, height: 560)
            let renderer = UIGraphicsImageRenderer(size: size)

            let image = renderer.image { context in
                let cg = context.cgContext
                let rect = CGRect(origin: .zero, size: size)

                // Fondo base oscuro translúcido
                let bgPath = UIBezierPath(roundedRect: rect, cornerRadius: 44)
                UIColor(red: 0.08, green: 0.17, blue: 0.14, alpha: 0.92).setFill()
                bgPath.fill()

                // Borde claro para mejorar contraste en AR
                UIColor(white: 1.0, alpha: 0.28).setStroke()
                bgPath.lineWidth = 6
                bgPath.stroke()

                // Icono ilustrado
                if let icon = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(
                    UIColor(red: 0.51, green: 0.89, blue: 0.57, alpha: 1),
                    renderingMode: .alwaysOriginal
                ) {
                    icon.draw(in: CGRect(x: 38, y: 34, width: 68, height: 68))
                }

                let headerStyle = NSMutableParagraphStyle()
                headerStyle.alignment = .left
                let headerAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                    .foregroundColor: UIColor(white: 1.0, alpha: 0.88),
                    .paragraphStyle: headerStyle
                ]
                let mainAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.monospacedSystemFont(ofSize: 86, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
                let subAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 38, weight: .medium),
                    .foregroundColor: UIColor(white: 1.0, alpha: 0.9)
                ]

                NSString(string: "BOVINO DETECTADO")
                    .draw(in: CGRect(x: 124, y: 40, width: 860, height: 60), withAttributes: headerAttrs)
                NSString(string: id)
                    .draw(in: CGRect(x: 40, y: 118, width: 920, height: 110), withAttributes: mainAttrs)

                // Badge de estado
                let badgeRect = CGRect(x: 40, y: 252, width: 220, height: 84)
                let badgePath = UIBezierPath(roundedRect: badgeRect, cornerRadius: 22)
                let statusColor: UIColor = status.uppercased() == "ACTIVO"
                    ? UIColor(red: 0.28, green: 0.72, blue: 0.35, alpha: 0.95)
                    : UIColor(red: 0.86, green: 0.58, blue: 0.24, alpha: 0.95)
                statusColor.setFill()
                badgePath.fill()

                let badgeAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 34, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
                NSString(string: status.uppercased())
                    .draw(in: CGRect(x: 78, y: 274, width: 170, height: 42), withAttributes: badgeAttrs)

                NSString(string: action)
                    .draw(in: CGRect(x: 40, y: 370, width: 940, height: 70), withAttributes: subAttrs)

                // Sombra suave inferior para separar del entorno
                cg.saveGState()
                cg.setShadow(offset: CGSize(width: 0, height: 12), blur: 20, color: UIColor.black.cgColor)
                UIColor.clear.setFill()
                cg.fill(CGRect(x: 0, y: size.height - 24, width: size.width, height: 1))
                cg.restoreGState()
            }

            guard let cgImage = image.cgImage else { return nil }

            do {
                return try TextureResource.generate(
                    from: cgImage,
                    options: .init(semantic: .color)
                )
            } catch {
                return nil
            }
        }

        private func updateBillboard(for anchorID: UUID, frame: ARFrame) {
            guard let poster = posterEntitiesByAnchorID[anchorID],
                  let anchorEntity = anchorEntitiesByID[anchorID] else {
                return
            }

            let cameraWorld = SIMD3<Float>(
                frame.camera.transform.columns.3.x,
                frame.camera.transform.columns.3.y,
                frame.camera.transform.columns.3.z
            )
            let anchorWorld = SIMD3<Float>(
                anchorEntity.transformMatrix(relativeTo: nil).columns.3.x,
                anchorEntity.transformMatrix(relativeTo: nil).columns.3.y,
                anchorEntity.transformMatrix(relativeTo: nil).columns.3.z
            )
            let posterWorld = anchorWorld + SIMD3<Float>(0, visualConfig.yOffset, 0)
            poster.setPosition(posterWorld, relativeTo: nil)

            // Rotación 3D estable apuntando a la cámara (sin giro tipo hélice).
            poster.look(
                at: cameraWorld,
                from: posterWorld,
                upVector: [0, 1, 0],
                relativeTo: nil,
                forward: .positiveZ
            )
        }
    }
}
