import Foundation
import HealthKit

public struct HealthKitSample {
    public let date: Date = .now
    public let bodyMass: Measurement<UnitMass>?
    public let leanBodyMass: Measurement<UnitMass>?
    public let bodyMassIndex: Double?
    public let bodyFatPercentage: Double?
    
    public init(bodyMass: Measurement<UnitMass>?, leanBodyMass: Measurement<UnitMass>?, bodyMassIndex: Double?, bodyFatPercentage: Double?) {
        self.bodyMass = bodyMass
        self.leanBodyMass = leanBodyMass
        self.bodyMassIndex = bodyMassIndex
        self.bodyFatPercentage = bodyFatPercentage
    }
}

extension HealthKitSample {
    
    func save(to healthStore: HKHealthStore) async throws {
        let samples = allSamples.filter {
            healthStore.authorizationStatus(for: $0.sampleType) == .sharingAuthorized
        }
        try await healthStore.save(samples)
    }
    
    var allSamples: [HKQuantitySample] {
        [
            bodyMassSample,
            leanBodyMassSample,
            bodyMassIndexSample,
            bodyFatPercentageSample
        ].compactMap { $0 }
    }
    
    var bodyMassSample: HKQuantitySample? {
        guard let bodyMass else { return nil }
        return HKQuantitySample(
            type: .bodyMass,
            quantity: .init(unit: .gram(), doubleValue: bodyMass.converted(to: .grams).value),
            start: date,
            end: date
        )
    }
    
    var leanBodyMassSample: HKQuantitySample? {
        guard let leanBodyMass else { return nil }
        return HKQuantitySample(
            type: .leanBodyMass,
            quantity: .init(unit: .gram(), doubleValue: leanBodyMass.converted(to: .grams).value),
            start: date,
            end: date
        )
    }
    
    var bodyMassIndexSample: HKQuantitySample? {
        guard let bodyMassIndex else { return nil }
        return HKQuantitySample(
            type: .bodyMassIndex,
            quantity: .init(unit: .count(), doubleValue: bodyMassIndex),
            start: date,
            end: date
        )
    }
    
    var bodyFatPercentageSample: HKQuantitySample? {
        guard let bodyFatPercentage else { return nil }
        return HKQuantitySample(
            type: .bodyFatPercentage,
            quantity: .init(unit: .percent(), doubleValue: bodyFatPercentage),
            start: date,
            end: date
        )
    }
}
