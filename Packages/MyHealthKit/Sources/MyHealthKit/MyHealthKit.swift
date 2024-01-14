import Foundation
import HealthKit

@MainActor
public protocol MyHealthKit {
    var isAvailable: Bool { get }
    var authorizationStatus: HealthKitAuthorization { get }
 
    func requestAuthorization() async throws
    func readBodyCharacteristics() async -> BodyCharacteristics
    func readPreferredUnits() async throws -> HealthKitUnits
    func share(sample: HealthKitSample) async throws
}

@MainActor
public class MyHealthKitImpl: MyHealthKit {
    
    private let healthStore = HKHealthStore()
    private let bodyCharacteristicsFactory: BodyCharacteristicsFactory
    
    public var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    public var authorizationStatus: HealthKitAuthorization {
        HealthKitAuthorization.determine(for: healthStore)
    }
    
    public init() {
        self.bodyCharacteristicsFactory = BodyCharacteristicsFactory(healthStore: healthStore)
    }
    
    public func requestAuthorization() async throws {
        try await HealthKitAuthorization.request(for: healthStore)
    }
    
    public func readBodyCharacteristics() async -> BodyCharacteristics {
        await bodyCharacteristicsFactory.readBodyCharacteristics()
    }
    
    public func readPreferredUnits() async throws -> HealthKitUnits {
        try await HealthKitUnits.preferredUnits(for: healthStore)
    }
    
    public func share(sample: HealthKitSample) async throws {
        try await sample.save(to: healthStore)
    }
}
