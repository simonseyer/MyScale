import Foundation
import AsyncBluetooth
import Combine
import OSLog
import CoreBluetooth

@Observable
class EufyC1Scale: Scale, BluetoothConnectable {
    
    private(set) var isConnected = false
    private(set) var batteryLevel: Int?
    private(set) var measurement: ScaleMeasurement?
    
    private let centralManager: CentralManager
    private var peripheral: Peripheral
    private var subscriptions: Set<AnyCancellable> = []
    
    private static let logger = Logger(subsystem: "ch.comeup.MyScale", category: "MyBluetooth.EufyC1Scale")
    private static let eufyService = CBUUID(string: "FFF0")
    private static let deviceInformationService = CBUUID(string: "180A")
    private static let deviceInformationCharacteristics = [
        ("System ID", CBUUID(string: "2A23")),
        ("Model Number String", CBUUID(string: "2A24")),
        ("Serial Number String", CBUUID(string: "2A25")),
        ("Firmware Revision String", CBUUID(string: "2A26")),
        ("Hardware Revision String", CBUUID(string: "2A27")),
        ("Software Revision String", CBUUID(string: "2A28")),
        ("Manufacturer Name String", CBUUID(string: "2A29"))
    ]
    private static let batteryService = CBUUID(string: "180F")
    private static let batteryCharacteristic = CBUUID(string: "2A19")
    private static let scaleService = CBUUID(string: "FFF0")
    private static let scaleCharacteristic = CBUUID(string: "FFF4")
    
    static var scannableServices = Set([eufyService])
    
    init(centralManager: CentralManager, peripheral: Peripheral) async throws {
        self.centralManager = centralManager
        self.peripheral = peripheral
        
        observeConnectionState()
        try await centralManager.connect(peripheral)
        try await observeMainCharacteristic()
        Task {
            await fetchBatteryLevel()
            await printDebugDeviceInformation()
        }
    }
    
    static func connect(scanData: ScanData, centralManager: CentralManager) async throws -> Scale {
        logger.debug("Manufacturer data: \(scanData.advertisementData)")
        // TODO: Validate Manufacturer data
        // TODO: parse initial state from Manufacturer data for more immediate values
        
        return try await EufyC1Scale(centralManager: centralManager, peripheral: scanData.peripheral)
    }
    
    func disconnect() async throws {
        try await centralManager.cancelPeripheralConnection(peripheral)
    }
    
    private func printDebugDeviceInformation() async {
        for deviceInfo in Self.deviceInformationCharacteristics {
            do {
                let value: Data? = try await peripheral.readValue(
                    forCharacteristicWithCBUUID: deviceInfo.1,
                    ofServiceWithCBUUID: Self.deviceInformationService
                )
                if let value {
                    Self.logger.debug("\(deviceInfo.0): \(value.hexEncodedString()) — \(String(data: value, encoding: .utf8) ?? "n/a")")
                }
            } catch {
                Self.logger.debug("\(deviceInfo.0): Failed to read value")
            }
        }
    }
    
    private func fetchBatteryLevel() async {
        do {
            batteryLevel = try await peripheral.readValue(
                forCharacteristicWithCBUUID: Self.batteryCharacteristic,
                ofServiceWithCBUUID: Self.batteryService
            )
        } catch {
            Self.logger.warning("Failed to read battery level: \(error)")
        }
    }
    
    private func observeMainCharacteristic() async throws {
        try await peripheral.setNotifyValue(true,
                                            forCharacteristicWithCBUUID: Self.scaleCharacteristic,
                                            ofServiceWithCBUUID: Self.scaleService)
        
        peripheral
            .characteristicValueUpdatedPublisher
            .sink { characteristic in
                guard let value = characteristic.value, let measurement = ScaleMeasurement(data: value) else {
                    return
                }
                print("-> \(measurement)")
                
                self.measurement = measurement
            }
            .store(in: &subscriptions)
    }
    
    private func observeConnectionState() {
        centralManager.eventPublisher
            .compactMap { event in
                guard event.peripheral?.identifier == self.peripheral.identifier else {
                    return nil
                }
                
                if case .didConnectPeripheral = event {
                    return true
                } else if case .didDisconnectPeripheral = event {
                    return false
                } else {
                    return nil
                }
            }
            .sink {
                self.isConnected = $0
            }
            .store(in: &subscriptions)
    }
}

extension ScaleMeasurement {
    fileprivate init?(data: Data) {
        guard data.count == 11 else {
            return nil
        }
        
        print(data.hexEncodedString())
        
        let fields = data.withUnsafeBytes {
            ($0.loadUnaligned(fromByteOffset: 0, as: UInt8.self), // constant
             $0.loadUnaligned(fromByteOffset: 1, as: UInt16.self), // impedance
             $0.loadUnaligned(fromByteOffset: 3, as: UInt16.self), // weight
             // Unknown fields
             $0.loadUnaligned(fromByteOffset: 9, as: UInt8.self), // status
             $0.loadUnaligned(fromByteOffset: 10, as: UInt8.self) // crc
            )
        }
        
        guard fields.0 == 0xcf else {
            return nil
        }
        
        self.impedance = Double(fields.1) / 10
        self.weight = .init(value: Double(fields.2) / 100, unit: .kilograms) // TODO: always kilograms?
        self.status = Status(rawValue: fields.3)
    }
}

extension ScaleMeasurement.Status {
    fileprivate init(rawValue: UInt8) {
        switch rawValue {
        case 0:
            self = .final
        case 1:
            self = .measuring
        case 2:
            self = .overWeight
        default:
            self = .unknown
        }
    }
}
