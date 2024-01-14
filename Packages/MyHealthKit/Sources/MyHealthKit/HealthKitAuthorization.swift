import Foundation
import HealthKit

public enum HealthKitAuthorization {
    /// No authorization was requested yet
    case notRequested
    /// Authorization was requested for some but not all relevant metrics
    case partiallyRequested
    /// At least one sharable metric is authorized
    case authorized
    /// All sharing was denied
    case denied
}

extension HealthKitAuthorization {
    static func determine(for healthStore: HKHealthStore) -> Self {
        let status = HKObjectType.allShareTypes.map {
            healthStore.authorizationStatus(for: $0)
        }
        if status.contains(.notDetermined) {
            if status.contains(.sharingAuthorized) || status.contains(.sharingDenied) {
                return .partiallyRequested
            } else {
                return .notRequested
            }
        } else if status.contains(.sharingAuthorized) {
            return .authorized
        } else {
            return .denied
        }
    }
    
    @MainActor
    static func request(for healthStore: HKHealthStore) async throws {
        try await healthStore.requestAuthorization(toShare: HKObjectType.allShareTypes,
                                                   read: HKObjectType.allReadTypes)
    }
}
