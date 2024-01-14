import Foundation
import HealthKit

extension BiologicalSex {
    init(_ sex: HKBiologicalSex) {
        switch sex {
        case .notSet:
            self = .unknown
        case .female:
            self = .female
        case .male:
            self = .male
        case .other:
            self = .unknown
        @unknown default:
            self = .unknown
        }
    }
}

class BodyCharacteristicsFactory {
    private let healthStore: HKHealthStore
    
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }
    
    func readBodyCharacteristics() async -> BodyCharacteristics {
        return BodyCharacteristics(
            birthDate: readBirthDate(),
            bodyHeight: await readBodyHeight(),
            biologicalSex: readBiologicalSex()
        )
    }
    
    private func readBirthDate() -> Date? {
        do {
            return try healthStore.dateOfBirthComponents().date
        } catch {
            logger.warning("Failed to read birthdate: \(error)")
            return nil
        }
    }
    
    private func readBiologicalSex() -> BiologicalSex {
        do {
            return BiologicalSex(try healthStore.biologicalSex().biologicalSex)
        } catch {
            logger.warning("Failed to read biological sex: \(error)")
            return BiologicalSex.unknown
        }
    }
    
    private func readBodyHeight() async -> Measurement<UnitLength>? {
        await withCheckedContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: .height,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [sortDescriptor]) { (query, results, error) in
                if let error {
                    logger.warning("Failed to read body height: \(error)")
                    continuation.resume(returning: .none)
                } else if let result = results?.first as? HKQuantitySample {
                    let heightInMeters = result.quantity.doubleValue(for: .meter())
                    let heightMeasurement = Measurement<UnitLength>(value: heightInMeters, unit: .meters)
                    continuation.resume(returning: heightMeasurement)
                } else {
                    logger.warning("Failed to read body height: No results")
                    continuation.resume(returning: .none)
                }
            }
            healthStore.execute(query)
        }
    }
}
