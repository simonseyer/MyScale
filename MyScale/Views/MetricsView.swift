import SwiftUI

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

            MetricsEntryView(symbol: "figure.mixed.cardio", title: "Lean Body Mass") {
                if let leanBodyMass = metrics.leanBodyMass {
                    Text(leanBodyMass.value, format: .number.precision(.fractionLength(1)))
                }
            } unit: {
                Text(massFormatter.string(from: metrics.leanBodyMass?.unit ?? UnitMass.kilograms))
            }

            MetricsEntryView(symbol: "percent", title: "Body Fat Percentage") {
                if let bodyFatPercentage = metrics.bodyFatPercentage {
                    Text(bodyFatPercentage * 100, format: .number.precision(.fractionLength(1)))
                }
            } unit: {
                Text("%")
            }

            MetricsEntryView(symbol: "figure.stand", title: "Body Mass Index") {
                if let bodyMassIndex = metrics.bodyMassIndex {
                    Text(bodyMassIndex, format: .number.precision(.fractionLength(1)))
                }
            } unit: {
                Text("BMI")
            }

        }
        .padding(.bottom)
    }
}

struct MetricsEntryView: View {
    let symbol: String
    let title: LocalizedStringResource
    let value: () -> Text?
    let unit: () -> Text
    
    init(symbol: String,
         title: LocalizedStringResource,
         @ViewBuilder value: @escaping () -> Text?,
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
                if let valueView = value() {
                    valueView
                        .font(.title)
                    unit()
                        .foregroundStyle(.secondary)
                } else {
                    Text("Missing HealthKit information")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
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
                                                  bodyHeight: .init(value: 183, unit: . centimeters),
                                                  biologicalSex: .unknown)
    return MetricsView(metrics: MyMetrics(
        measurement: measurement,
        bodyCharacteristics: bodyCharacteristics,
        units: nil)
    )
}
