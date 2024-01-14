import Foundation
import CoreBluetooth
import AsyncBluetooth

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}

extension CentralManagerEvent {
    var peripheral: Peripheral? {
        switch self {
        case .didConnectPeripheral(let peripheral):
            peripheral
        case .didDisconnectPeripheral(let peripheral, _, _):
            peripheral
        default:
            nil
        }
    }
}

extension [String: Any] {
    var serviceUUIDs: Set<CBUUID> {
        Set(self[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? [])
    }
}
