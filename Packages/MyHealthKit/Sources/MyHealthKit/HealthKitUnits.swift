import Foundation
import HealthKit

public struct HealthKitUnits {
    public let bodyMass: UnitMass
    public let leanBodyMass: UnitMass
}

extension HealthKitUnits {
    static func preferredUnits(for healthStore: HKHealthStore) async throws -> Self {
        let units = try await healthStore.preferredUnits(for: HKObjectType.allShareTypes)
        func massUnit(for type: HKQuantityType) -> UnitMass {
            UnitMass.from(massFormatterUnit: HKUnit.massFormatterUnit(from: units[type]!))
        }
        
        return HealthKitUnits(
            bodyMass: massUnit(for: .bodyMass),
            leanBodyMass: massUnit(for: .leanBodyMass)
        )
    }
}

extension UnitMass {
    static func from(massFormatterUnit unit: MassFormatter.Unit) -> UnitMass {
        switch unit {
        case .gram:
            .grams
        case .kilogram:
            .kilograms
        case .ounce:
            .ounces
        case .pound:
            .pounds
        case .stone:
            .stones
        @unknown default:
            fatalError("Unexpected mass unit")
        }
    }
}
