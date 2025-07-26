import Foundation
import HealthKit
import os

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

struct BodyCharacteristicsFactory {
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
        do {
            let samples = try await executeHeightQuery()
            return processHeightSamples(samples)
        } catch {
            logger.warning("Failed to read body height: \(error)")
            return nil
        }
    }
    
    private func executeHeightQuery() async throws -> [HKSample]? {
        try await withCheckedThrowingContinuation { continuation in
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: .height,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [sortDescriptor]) { (query, results, error) in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: results)
                }
            }
            healthStore.execute(query)
        }
    }
    
    private func processHeightSamples(_ samples: [HKSample]?) -> Measurement<UnitLength>? {
        guard let result = samples?.first as? HKQuantitySample else {
            logger.warning("Failed to read body height: No results")
            return nil
        }
        
        let heightInMeters = result.quantity.doubleValue(for: .meter())
        return Measurement<UnitLength>(value: heightInMeters, unit: .meters)
    }
}
