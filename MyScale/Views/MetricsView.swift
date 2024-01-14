import SwiftUI
import MyBluetooth
import MyHealthKit

struct MetricsView: View {
    
    let metrics: MyMetrics
    let massFormatter = MeasurementFormatter()
    
    var body: some View {
        VStack(spacing: 10) {
            MetricsEntryView(symbol: "scalemass", title: "Weight") {
                Text(metrics.bodyMass.value, format: .number.precision(.fractionLength(1)))
            } unit: {
                Text(massFormatter.string(from: metrics.bodyMass.unit))
            }
            if let leanBodyMass = metrics.leanBodyMass {
                MetricsEntryView(symbol: "figure.mixed.cardio", title: "Lean Body Mass") {
                    Text(leanBodyMass.value, format: .number.precision(.fractionLength(1)))
                } unit: {
                    Text(massFormatter.string(from: leanBodyMass.unit))
                }
            }
            
            if let bodyFatPercentage = metrics.bodyFatPercentage {
                MetricsEntryView(symbol: "percent", title: "Body Fat Percentage") {
                    Text(bodyFatPercentage * 100, format: .number.precision(.fractionLength(1)))
                } unit: {
                    Text("%")
                }
            }
            
            if let bodyMassIndex = metrics.bodyMassIndex {
                MetricsEntryView(symbol: "figure.stand", title: "Body Mass Index") {
                    Text(bodyMassIndex, format: .number.precision(.fractionLength(1)))
                } unit: {
                    Text("BMI")
                }
            }
        }
        .padding(.bottom)
    }
}

struct MetricsEntryView: View {
    let symbol: String
    let title: LocalizedStringResource
    let value: () -> Text
    let unit: () -> Text
    
    init(symbol: String,
         title: LocalizedStringResource,
         @ViewBuilder value: @escaping () -> Text,
         @ViewBuilder unit: @escaping () -> Text) {
        self.symbol = symbol
        self.title = title
        self.value = value
        self.unit = unit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(Image(systemName: symbol)) \(title)")
                .font(.system(size: 14, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(.tint)
                .padding(.bottom, 6)
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                value()
                    .font(.title)
                unit()
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 26)
        .background(RoundedRectangle(cornerRadius: 15.0).foregroundStyle(.background.secondary))
    }
}

#Preview {
    let measurement = ScaleMeasurement(
        weight: .init(value: 66, unit: .kilograms),
        impedance: 500,
        status: .final
    )
    let bodyCharacteristics = BodyCharacteristics(birthDate: nil,
                                                  bodyHeight: nil,
                                                  biologicalSex: .unknown)
    return MetricsView(metrics: MyMetrics(
        measurement: measurement,
        bodyCharacteristics: bodyCharacteristics,
        units: nil)
    )
}
