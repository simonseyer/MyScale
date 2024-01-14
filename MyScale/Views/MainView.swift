import SwiftUI
import MyBluetooth
import MyHealthKit

@MainActor
struct MainView: View {
    
    private let bluetooth = MyBluetoothImpl()
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

struct BluetoothStatusView: View {
    
    let bluetoothState: BluetoothState
    
    var body: some View {
        switch bluetoothState {
        case .poweredOff:
            Text("Please turn on Bluetooth")
        case .poweredOn:
            Text("Ready to scan")
        case .resetting, .unknown:
            ProgressView()
        case .unauthorized:
            Text("Please give the app Bluetooth permission")
        case .unsupported:
            Text("Unfortunatly Bluetooth is not supported on this device")
        }
    }
}

#Preview {
    MainView()
}
