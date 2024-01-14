import Foundation

public protocol Scale: Observable {
    var isConnected: Bool { get }
    var batteryLevel: Int? { get }
    var measurement: ScaleMeasurement? { get }
    
    func disconnect() async throws
}

public struct ScaleMeasurement: Hashable, Identifiable {
    public var id: Int {
        hashValue
    }
    
    public let weight: Measurement<UnitMass>
    public let impedance: Double
    public let status: Status
    
    public enum Status {
        case final
        case measuring
        case overWeight
        case unknown
    }
    
    public init(weight: Measurement<UnitMass>, impedance: Double, status: Status) {
        self.weight = weight
        self.impedance = impedance
        self.status = status
    }
}
