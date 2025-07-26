import SwiftUI

struct BluetoothStatusView: View {
    
    let bluetoothState: BluetoothState
    
    var body: some View {
        switch bluetoothState {
        case .poweredOff:
            ContentUnavailableView("Please turn on Bluetooth",
                                   systemImage: "lightswitch.on")
        case .poweredOn:
            EmptyView()
        case .resetting, .unknown:
            ProgressView()
        case .unauthorized:
            ContentUnavailableView("Please give the app Bluetooth permission in the system settings",
                                   systemImage: "hand.raised")
        case .unsupported:
            ContentUnavailableView("Unfortunatly Bluetooth is not supported on this device",
                                   systemImage: "exclamationmark.octagon")
        }
    }
}

#Preview("Off") {
    BluetoothStatusView(bluetoothState: .poweredOff)
}

#Preview("Loading") {
    BluetoothStatusView(bluetoothState: .unknown)
}

#Preview("Unauhtorized") {
    BluetoothStatusView(bluetoothState: .unauthorized)
}

#Preview("Unsupported") {
    BluetoothStatusView(bluetoothState: .unsupported)
}
