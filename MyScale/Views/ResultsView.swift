import SwiftUI
import MyBluetooth
import MyHealthKit

@MainActor
struct ResultsView: View {
    
    let measurement: ScaleMeasurement
    let healthKit: MyHealthKit

    @State var isSynchronized = false
    @State var metrics: MyMetrics?
    
    private var healthKitStatus: HealthKitStatus {
        if !healthKit.isAvailable {
            return .unavailable
        } else if healthKit.authorizationStatus == .notRequested {
            return .setupNeeded
        } else if healthKit.authorizationStatus == .denied {
            return .setupNeeded // TODO: dedicate status
        } else if healthKit.authorizationStatus == .partiallyRequested {
            return .setupNeeded // TODO: dedicate status
        } else if isSynchronized {
            return .synchronized
        }
        // TODO: handle all states
        return .idle
    }
    
    var body: some View {
        ScrollView {
            if let metrics {
                MetricsView(metrics: metrics)
            }
            
            AppleHealthStatusView(status: healthKitStatus) {
                // TODO: help/revert action
            } appleHealthAction: {
                Task {
                    // TODO: fix jerky animation of HealthKit dialog
                    try await healthKit.requestAuthorization()
                    await updateMetrics(animated: true)
                }
            }

        }
        .padding(.horizontal)
        .navigationTitle("Measurement")
        .task {
            await updateMetrics(animated: false)
        }
    }
    
    private func updateMetrics(animated: Bool) async {
        let metrics = await MyMetrics(measurement: measurement,
                                  healthKit: healthKit)
        if animated {
            withAnimation {
                self.metrics = metrics
            }
        } else {
            self.metrics = metrics
        }
        
        if !isSynchronized && healthKit.authorizationStatus == .authorized {
            do {
                try await healthKit.share(sample: .init(
                    bodyMass: metrics.bodyMass,
                    leanBodyMass: metrics.leanBodyMass,
                    bodyMassIndex: metrics.bodyMassIndex,
                    bodyFatPercentage: metrics.bodyFatPercentage)
                )
                withAnimation {
                    isSynchronized = true
                }
            } catch {
                print("TODO: Failed \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        let healthKit = MyHealthKitImpl()
        let measurement = ScaleMeasurement(
            weight: .init(value: 66, unit: .kilograms),
            impedance: 500,
            status: .final
        )
        ResultsView(measurement: measurement,
                    healthKit: healthKit)
    }
}


