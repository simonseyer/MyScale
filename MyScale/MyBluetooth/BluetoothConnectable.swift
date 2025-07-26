import Foundation
import AsyncBluetooth
import CoreBluetooth

@MainActor
protocol BluetoothConnectable {
    static var scannableServices: Set<CBUUID> { get }
    
    static func connect(scanData: ScanData, centralManager: CentralManager) async throws -> any Scale
}
