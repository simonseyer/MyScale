import Foundation

protocol Scale: Observable {
    var isConnected: Bool { get }
    var batteryLevel: Int? { get }
    var measurement: ScaleMeasurement? { get }
    
    func disconnect() async throws
}

struct ScaleMeasurement: Hashable, Identifiable {
    var id: Int {
        hashValue
    }
    
    let weight: Measurement<UnitMass>
    let impedance: Double
    let status: Status
    
    enum Status {
        case final
        case measuring
        case overWeight
        case unknown
    }
    
    init(weight: Measurement<UnitMass>, impedance: Double, status: Status) {
        self.weight = weight
        self.impedance = impedance
        self.status = status
    }
}
