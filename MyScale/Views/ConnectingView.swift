import SwiftUI

struct ConnectingView: View {
    
    let bluetooth: any MyBluetooth
    @Binding var scale: (any Scale)?
    
    @State private var shouldScan = true
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            Text("Step on your scale")
                .padding()
            Image(systemName: "dot.radiowaves.left.and.right")
                .symbolEffect(.variableColor.iterative, options: .repeating)
                .bold()
        }
        .font(.largeTitle)
        .foregroundStyle(.tint)
        .task(id: shouldScan) {
            try? await connectToScale()
        }
        .onChange(of: scenePhase) {
            shouldScan = scenePhase == .active
        }
    }
    
    func connectToScale() async throws {
        while shouldScan && scale == nil {
            try Task.checkCancellation()
            do {
                scale = try await bluetooth.connectToNearbyScale()
            } catch {
                // Handle
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    ConnectingView(bluetooth: MyBluetoothImpl(), scale: .constant(nil))
}
