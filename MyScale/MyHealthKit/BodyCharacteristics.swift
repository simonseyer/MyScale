import Foundation

enum BiologicalSex {
    case male, female, unknown
}

struct BodyCharacteristics {
    let birthDate: Date?
    let bodyHeight: Measurement<UnitLength>?
    let biologicalSex: BiologicalSex
    
    var age: Double? {
        guard let birthDate else { return nil }
        let ageComponents = Calendar.current.dateComponents([.year, .day], from: birthDate, to: .now)
        return Double(ageComponents.year ?? 0) + Double(ageComponents.day ?? 0) / 365.0
    }
    
    init(birthDate: Date?, bodyHeight: Measurement<UnitLength>?, biologicalSex: BiologicalSex) {
        self.birthDate = birthDate
        self.bodyHeight = bodyHeight
        self.biologicalSex = biologicalSex
    }
}
