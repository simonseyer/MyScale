//
//  AppleHealthStatusView.swift
//  MyScale
//
//  Created by Simon Seyer on 11.01.2024.
//

import SwiftUI

enum HealthKitStatus {
    case unavailable, setupNeeded, idle, synchronizing
    case synchronizationFailed, synchronized, reverted
}


struct AppleHealthStatusView: View {
    
    let status: HealthKitStatus
    let statusAction: () -> Void
    let appleHealthAction: () -> Void
    
    @ViewBuilder
    private var statusVisual: some View {
        switch status {
        case .unavailable, .setupNeeded:
            EmptyView()
        case .idle, .synchronizing:
            ProgressView()
                .controlSize(.small)
        case .synchronized:
            Image(systemName: "checkmark")
                .foregroundStyle(.tint)
                .fontWeight(.semibold)
        case .reverted:
            Image(systemName: "arrow.counterclockwise")
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
        case .synchronizationFailed:
            Image(systemName: "exclamationmark.circle")
                .foregroundStyle(.orange)
                .fontWeight(.semibold)
        }
    }
    
    var body: some View {
        if status == .unavailable {
            Text("Apple Health is not available on this device")
                .foregroundStyle(.secondary)
                .font(.caption)
        } else if status == .setupNeeded {
            Button(action: appleHealthAction) {
                Text("\(Image(systemName: "heart.fill")) Connect to Apple Health")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 4)
            Text("Use your body metrics in Apple Health (age, height & sex) to calculate BMI, body fat percentage and lean body mass. They are then sent to the Health app on every measurement.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        } else {
            Button(action: statusAction) {
                HStack(spacing: 8) {
                    statusVisual
                        .frame(width: 14)
                        .transition(.scale.animation(.snappy))
                    Text("Apple Health Sync")
                }
            }
            .buttonStyle(.plain)
            .font(.caption)
        }
    }
}

fileprivate struct AppleHealthStatusTestView: View {
    @State var status: HealthKitStatus = .synchronizing
    var body: some View {
        AppleHealthStatusView(status: status, statusAction: {}, appleHealthAction: {})
        Button("Toggle state") {
            if status == .synchronizing {
                status = .synchronized
            } else if status == .synchronized {
                status = .reverted
            } else if status == .reverted {
                status = .synchronizing
            }
        }
        .tint(.blue)
        .padding()
        .controlSize(.mini)
    }
}

#Preview {
    VStack {
        AppleHealthStatusView(status: .unavailable, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusView(status: .setupNeeded, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusView(status: .idle, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusView(status: .synchronizing, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusView(status: .synchronized, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusView(status: .reverted, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusView(status: .synchronizationFailed, statusAction: {}, appleHealthAction: {})
        Divider().padding()
        AppleHealthStatusTestView()
    }
    
}
