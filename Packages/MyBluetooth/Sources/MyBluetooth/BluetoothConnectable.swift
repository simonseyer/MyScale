import Foundation
import AsyncBluetooth
import CoreBluetooth

protocol BluetoothConnectable {
    static var scannableServices: Set<CBUUID> { get }
    
    static func connect(scanData: ScanData, centralManager: CentralManager) async throws -> Scale
}
