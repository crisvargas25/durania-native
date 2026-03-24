# Durania App

## Proposito
App iOS de gestion de ganado bovino para productores en Durango, Mexico. Permite identificar, rastrear y registrar el estado sanitario del hato.

## Stack
- Swift + SwiftUI (iOS 17+)
- ARKit + RealityKit — escaneo AR con image tracking
- AVFoundation — escaneo QR con camara
- MapKit — ubicacion del ganado en mapa
- SwiftData — integrado con modelos de negocio (`Bovine`, `Vaccine`, `HealthEvent`)

## Estado actual

### Persistencia local con SwiftData (activo)
Los modelos `Bovine`, `Vaccine` y `HealthEvent` son `@Model class` con SwiftData.
El schema esta configurado en `durania_appApp.swift` con `[Bovine.self, Vaccine.self, HealthEvent.self]`.
Al primer arranque, `seedInitialDataIfNeeded()` inserta los 4 bovinos iniciales si el store esta vacio (detectado con `fetchCount == 0`).

### NFC simulado (importante)
No hay integracion real con CoreNFC porque no se cuenta con el Apple Developer Program activo.
`NFCService.startSimulatedScan` devuelve siempre el bovino `MX-20394` tras 1 segundo de delay simulado.
No modificar esto hasta tener el Developer Program.

### Datos en vivo (SwiftData)
- `HomeView` — estadisticas reales con `@Query var bovines: [Bovine]`
- `CattleListView` — lista real con `@Query(sort: \Bovine.earTag)`
- `AddCattleView` — guarda nuevo `Bovine` via `modelContext.insert(bovine)`
- `BovineScanViewModel` — busca bovinos en SwiftData con `FetchDescriptor<Bovine>` por earTag
- `ScanView` — inyecta `modelContext` al ViewModel via `.onAppear`
- `ARView` (ARScanView) — recibe closure `bovineInfo` que consulta SwiftData para mostrar estado real en el poster AR

### Ubicacion (mock pendiente de backend)
`CattleLocationView` sigue usando coordenadas fijas hardcodeadas en Durango.
No modificar hasta tener el backend listo para proveer lat/long reales.

### Archivos template de Xcode eliminados
- `ContentView.swift` — eliminado
- `Item.swift` — eliminado
- `Cattle.swift` — modelo redundante eliminado, reemplazado por `Bovine`

### ReportsView
Esqueleto UI sin datos reales. Pendiente de implementar.

## Estructura de navegacion
`MainTabView` con 5 pestanas:
1. `HomeView` — dashboard con estadisticas reales desde SwiftData y grafica manual
2. `CattleListView` → `BovineDetailView` — lista con busqueda, detalle y edicion
3. `ScanView` — NFC (simulado) / QR (real con AVFoundation) / AR (real con ARKit)
4. `ReportsView` — esqueleto UI, sin datos
5. `CattleLocationView` — mapa MapKit + lista con coordenadas mock

## Modelos clave
- `Bovine` — `@Model class`: earTag, name, breed, sex, weight, healthStatus, lastVaccine, ranch, vaccines, events
- `Vaccine` — `@Model class`: name, dose, date, batch, nextDose, bovine (inversa)
- `HealthEvent` — `@Model class`: title, details (prop), date, bovine (inversa). Init acepta `description:` como label para compatibilidad
- `CowLocation` — struct para el mapa: lat/lon + estado de movimiento
- `Ranch`, `Producer` — definidos pero sin uso en vistas todavia

### Relaciones SwiftData
```
Bovine
  @Relationship(deleteRule: .cascade) var vaccines: [Vaccine]
  @Relationship(deleteRule: .cascade) var events: [HealthEvent]
```

## Catalogo de bovinos (seed inicial)
| Arete | Nombre | Raza | Estado |
|-------|--------|------|--------|
| MX-20394 | Luna | Angus | Sano |
| MX-20395 | Niebla | Brahman | Observacion |
| MX-20396 | Rayo | Charolais | Cuarentena |
| MX-20397 | Brisa | Angus | Sano |

Todos en "Rancho El Roble", Durango.
Insertados al primer arranque por `seedInitialDataIfNeeded()` en `durania_appApp.swift`.

## Edicion de bovinos
`BovineDetailView` tiene boton "Editar" en el toolbar que abre `EditBovineView` como sheet.
`EditBovineView` permite modificar: estado sanitario, nombre, peso, edad, rancho.
El earTag es de solo lectura.
Al guardar, se modifican las propiedades del `@Model` directamente — SwiftData persiste automaticamente.

## Paleta de colores
- `AppColors.tealGreen` — #00A385 (verde principal de accion)
- `AppColors.forestGreen` — #00493A (verde oscuro para titulos)
- `AppColors.lint` — verde claro (#D7D7A8)

## Patrones de escaneo
El `BovineScanViewModel` acepta dos formatos de arete:
- Directo: `MX-20394`
- Como path de URL: `https://api.durania.app/bovine/MX-20394`

Regex de validacion: `^[A-Z]{2}-[0-9]{3,}$`

## Imagenes AR
El grupo de imagenes de referencia en Assets se llama `CodigosGanado`.
El nombre de cada imagen debe coincidir con el arete del bovino (ej. `MX-20394`).
El poster AR muestra estado sanitario real consultando SwiftData via closure `bovineInfo`.
