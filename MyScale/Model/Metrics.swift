import Foundation
import MyBluetooth
import MyHealthKit

struct MyMetrics {
    let bodyMass: Measurement<UnitMass>
    let leanBodyMass: Measurement<UnitMass>?
    let bodyMassIndex: Double?
    let bodyFatPercentage: Double?
    
    public init(measurement: ScaleMeasurement, healthKit: MyHealthKit) async {
        let units = try? await healthKit.readPreferredUnits()
        let characteristics = await healthKit.readBodyCharacteristics()
        self.init(measurement: measurement, bodyCharacteristics: characteristics, units: units)
    }
    
    public init(measurement: ScaleMeasurement, bodyCharacteristics: BodyCharacteristics, units: HealthKitUnits?) {
        let defaultBodyMassUnit = UnitMass(forLocale: .autoupdatingCurrent, usage: .personWeight)
        let heightInMeters = bodyCharacteristics.bodyHeight?.converted(to: .meters).value
        let weightInKilograms = measurement.weight.converted(to: .kilograms).value
        
        self.bodyMass = measurement.weight.converted(to: units?.bodyMass ?? defaultBodyMassUnit)
        
        bodyMassIndex = if let heightInMeters {
            weightInKilograms / pow(heightInMeters, 2)
        } else {
            nil
        }
        
        if let heightInMeters, let age = bodyCharacteristics.age {
            let fatPercentage = Self.getFatPercentage(sex: bodyCharacteristics.biologicalSex,
                                                 age: age,
                                                 weight: weightInKilograms,
                                                 impedance: measurement.impedance,
                                                 height: heightInMeters)
            self.bodyFatPercentage = fatPercentage
            self.leanBodyMass =  measurement.weight.converted(to: units?.leanBodyMass ?? defaultBodyMassUnit) * (1.0 - fatPercentage)
        } else {
            self.bodyFatPercentage = nil
            self.leanBodyMass = nil
        }
    }
    
    private static func getLBMCoefficient(height: Double, weight: Double, impedance: Double, age: Double) -> Double {
        var lbm = (height * 9.058) * height
        lbm += weight * 0.32 + 12.226
        lbm -= impedance * 0.0068
        lbm -= age * 0.0542
        return lbm
    }
    
    private static func getFatPercentage(sex: BiologicalSex, age: Double, weight: Double, impedance: Double, height: Double) -> Double {
        var const: Double = 0.0
        var coefficient: Double = 1.0
        let lbm = getLBMCoefficient(height: height, weight: weight, impedance: impedance, age: Double(age))

        if sex == .female && age <= 49 {
            const = 9.25
        } else if sex == .female && age > 49 {
            const = 7.25
        } else {
            const = 0.8
        }

        if sex == .male && weight < 61 {
            coefficient = 0.98
        } else if sex == .female && weight > 60 {
            coefficient = 0.96
            if height > 1.6 {
                coefficient *= 1.03
            }
        } else if sex == .female && weight < 50 {
            coefficient = 1.02
            if height > 1.6 {
                coefficient *= 1.03
            }
        }

        var fatPercentage = 1.0 - (((lbm - const) * coefficient) / weight)

        // Capping body fat percentage
        if fatPercentage > 0.63 {
            fatPercentage = 0.75
        }

        return fatPercentage
    }
}
