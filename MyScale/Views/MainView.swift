import SwiftUI

@MainActor
struct MainView: View {
    
    let bluetooth: MyBluetooth
    private let healthKit = MyHealthKitImpl()
    
    @State private var scale: Scale?
//    @State private var measurement: ScaleMeasurement?
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
//                measurement != nil || 
                if bluetooth.state != .poweredOn {
                    BluetoothStatusView(bluetoothState: bluetooth.state)
                } else if let scale {
                    MeasureView(scale: scale) { measurement in
                        path.append(measurement)
                    }
                } else {
                    ConnectingView(bluetooth: bluetooth, scale: $scale)
                }
            }
            .padding()
            .task {
                try? await bluetooth.waitUntilReady()
            }
            .onChange(of: scale?.isConnected) {
                if scale?.isConnected == false {
                    scale = nil
                }
            }
//            .onChange(of: measurement) {
//                if let measurement = measurement {
//                    path.append(measurement)
//                }
//            }
            .navigationDestination(for: ScaleMeasurement.self) { measurement in
                ResultsView(measurement: measurement,
                            healthKit: healthKit)
            }
            // TODO: show as sheet again when HealthKit dialog issues are fixed
//            .sheet(item: $measurement) { measurement in
//                NavigationStack {
//                    ResultsView(measurement: measurement,
//                                healthKit: healthKit)
//                }
//            }
        }
        
    }
}

@Observable
class MyBluetoothPreview: MyBluetooth {
    var state: BluetoothState = .unknown
    var isConnecting: Bool = false

    func waitUntilReady() async throws {
        state = .poweredOn
    }
    
    func connectToNearbyScale() async throws -> any Scale {
        isConnecting = true
        let scale = PreviewScale()
        try await Task.sleep(for: .seconds(2))
        Task {
            try await Task.sleep(for: .seconds(2))
            scale.measurement = .init(weight: .init(value: 66, unit: .kilograms),
                                      impedance: 500,
                                      status: .final)
        }
        return scale
    }
    

}

#Preview {
    MainView(bluetooth: MyBluetoothPreview())
}
