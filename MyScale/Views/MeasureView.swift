import SwiftUI
import MyBluetooth

struct MeasureView: View {
    
    let scale: Scale
    let onFinalMeasurement: (ScaleMeasurement) -> Void
    
    var weight: Measurement<UnitMass> {
        if let measurement = scale.measurement {
            measurement.weight
        } else {
            .init(value: 0, unit: .kilograms)
        }
    }
    
    var isMeasuring: Bool {
        if let measurement = scale.measurement {
            measurement.status == .measuring
        } else {
            true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "scalemass.fill")
                Text(weight.formatted(.measurement(width: .abbreviated, usage: .personWeight, numberFormatStyle: .number.precision(.integerAndFractionLength(integer: 2, fraction: 1)))))
                    .monospacedDigit()
            }
            .font(.largeTitle)
            .foregroundStyle(.tint)
            .symbolEffect(.pulse, options: .repeating.speed(2.5), isActive: isMeasuring)
            HStack {
                Image(systemName: "battery.25")
                Text(scale.batteryLevel ?? 0, format: .percent)
            }
            .foregroundStyle(.secondary)
            .opacity(scale.batteryLevel != nil ? 1 : 0)
            .animation(.default.speed(2), value: scale.batteryLevel)
        }
        .onChange(of: scale.measurement) {
            if let measurement = scale.measurement, measurement.status == .final {
                //                measurement = scale.measurement
                // TODO: called more than once?
                onFinalMeasurement(measurement)
                Task {
                    try? await scale.disconnect()
                }
            }
        }
    }
}

class PreviewScale: Scale {
    
    var isConnected = true
    
    var batteryLevel: Int? = 50
    
    var measurement: ScaleMeasurement? = .init(
        weight: .init(value: 66, unit: .kilograms),
        impedance: 500,
        status: .measuring
    )
    
    func disconnect() async throws {
        isConnected = false
    }
}

#Preview {
    MeasureView(scale: PreviewScale()) { _ in }
}
