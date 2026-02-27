import Foundation

enum ScanSource {
    case nfc
    case qr
}

struct NFCTagData {
    let rawValue: String
    let source: ScanSource
    let scannedAt: Date
}
