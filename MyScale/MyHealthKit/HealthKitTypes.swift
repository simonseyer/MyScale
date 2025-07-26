import Foundation
import HealthKit

extension HKObjectType {
    // Shareable types
    static let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)!
    static let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
    static let bodyFatPercentage = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!
    static let leanBodyMass = HKObjectType.quantityType(forIdentifier: .leanBodyMass)!
    static let allShareTypes: Set<HKQuantityType> = [
        bodyMass,
        bodyMassIndex,
        bodyFatPercentage,
        leanBodyMass
    ]
    
    // Readable types
    static let height = HKObjectType.quantityType(forIdentifier: .height)!
    static let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
    static let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
    static let allReadTypes: Set<HKObjectType> = [
        height,
        biologicalSex,
        dateOfBirth
    ]
}
