import Foundation
import CoreBluetooth
import AsyncBluetooth
import Combine
import OSLog

public enum BluetoothState {
    case poweredOff, poweredOn, resetting, unauthorized, unknown, unsupported
}

@MainActor
public protocol MyBluetooth: Observable {
    var state: BluetoothState { get }
    var isConnecting: Bool { get }
    
    func waitUntilReady() async throws
    func connectToNearbyScale() async throws -> Scale
}

enum ScaleDiscoveryError: Error {
    case scanAlreadyInProgress
    case noScaleFound
}

@Observable
@MainActor
public class MyBluetoothImpl: MyBluetooth {
    
    public private(set) var state: BluetoothState
    public private(set) var isConnecting = false
    
    private let centralManager: CentralManager
    private var subscriptions: Set<AnyCancellable> = []
    
    private static let logger = Logger(subsystem: "ch.comeup.MyScale", category: "MyBluetooth")
    private static var connectableScales: [BluetoothConnectable.Type] = [
        EufyC1Scale.self
    ]
    
    public init(centralManager: CentralManager = .init()) {
        self.centralManager = centralManager
        self.state = .init(centralManager.bluetoothState)
        
        centralManager.eventPublisher
            .compactMap { event in
                if case .didUpdateState(let state) = event {
                    BluetoothState(state)
                } else {
                    nil
                }
            }
            .sink {
                self.state = $0
                Self.logger.info("Bluetooth state: \(String(reflecting: $0))")
            }
            .store(in: &subscriptions)
    }
    
    public func waitUntilReady() async throws {
        try await centralManager.waitUntilReady()
    }
    
    public func connectToNearbyScale() async throws -> Scale {
        guard !isConnecting else {
            throw ScaleDiscoveryError.scanAlreadyInProgress
        }
        
        try await centralManager.waitUntilReady()
        
        isConnecting = true
        defer {
            isConnecting = false
        }
        
        let services = Self.connectableScales.flatMap { $0.scannableServices }
        let scanDataStream = try await centralManager.scanForPeripherals(withServices: services)
        
        for await scanData in scanDataStream {
            if let scale = await connectScale(with: scanData) {
                return scale
            }
        }
        
        throw ScaleDiscoveryError.noScaleFound
    }
    
    private func connectScale(with scanData: ScanData) async -> Scale? {
        let scannables = Self.connectableScales.filter { connectable in
            !scanData.advertisementData.serviceUUIDs.isDisjoint(with: connectable.scannableServices)
        }
        for scannable in scannables {
            do {
                return try await scannable.connect(scanData: scanData, centralManager: centralManager)
            } catch {
                Self.logger.warning("Failed to connect to scale: \(error)")
            }
        }
        return nil
    }
}

extension BluetoothState {
    init(_ managerState: CBManagerState) {
        switch managerState {
        case .unknown:
            self = .unknown
        case .resetting:
            self = .resetting
        case .unsupported:
            self = .unsupported
        case .unauthorized:
            self = .unauthorized
        case .poweredOff:
            self = .poweredOff
        case .poweredOn:
            self = .poweredOn
        @unknown default:
            self = .unknown
        }
    }
}
