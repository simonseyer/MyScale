import Foundation
import HealthKit

protocol MyHealthKit {
    var isAvailable: Bool { get }
    var authorizationStatus: HealthKitAuthorization { get }
 
    func requestAuthorization() async throws
    func readBodyCharacteristics() async -> BodyCharacteristics
    func readPreferredUnits() async throws -> HealthKitUnits
    func share(sample: HealthKitSample) async throws
}

struct MyHealthKitImpl: MyHealthKit {

    private let healthStore = HKHealthStore()
    private let bodyCharacteristicsFactory: BodyCharacteristicsFactory
    
    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    var authorizationStatus: HealthKitAuthorization {
        HealthKitAuthorization.determine(for: healthStore)
    }
    
    init() {
        self.bodyCharacteristicsFactory = BodyCharacteristicsFactory(healthStore: healthStore)
    }
    
    func requestAuthorization() async throws {
        try await HealthKitAuthorization.request(for: healthStore)
    }
    
    func readBodyCharacteristics() async -> BodyCharacteristics {
        await bodyCharacteristicsFactory.readBodyCharacteristics()
    }
    
    func readPreferredUnits() async throws -> HealthKitUnits {
        try await HealthKitUnits.preferredUnits(for: healthStore)
    }
    
    func share(sample: HealthKitSample) async throws {
        try await sample.save(to: healthStore)
    }
}
