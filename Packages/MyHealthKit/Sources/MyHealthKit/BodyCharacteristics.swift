import Foundation

public enum BiologicalSex {
    case male, female, unknown
}

public struct BodyCharacteristics {
    public let birthDate: Date?
    public let bodyHeight: Measurement<UnitLength>?
    public let biologicalSex: BiologicalSex
    
    public var age: Double? {
        guard let birthDate else { return nil }
        let ageComponents = Calendar.current.dateComponents([.year, .day], from: birthDate, to: .now)
        return Double(ageComponents.year ?? 0) + Double(ageComponents.day ?? 0) / 365.0
    }
    
    public init(birthDate: Date?, bodyHeight: Measurement<UnitLength>?, biologicalSex: BiologicalSex) {
        self.birthDate = birthDate
        self.bodyHeight = bodyHeight
        self.biologicalSex = biologicalSex
    }
}
