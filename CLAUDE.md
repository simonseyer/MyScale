# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MyScale is a SwiftUI iOS/macOS app that connects to Bluetooth-enabled smart scales (specifically Eufy C1 Scale) to capture body measurements and integrates with Apple HealthKit. The app calculates body metrics like BMI, body fat percentage, and lean body mass using proprietary algorithms.

## Development Commands

### Building and Testing
- **Build the project**: Open `MyScale.xcodeproj` in Xcode and use Cmd+B to build
- **Run tests**: Use Cmd+U in Xcode to run unit tests (`MyScaleTests`) and UI tests (`MyScaleUITests`)
- **Run on device/simulator**: Use Cmd+R in Xcode

## Architecture Overview

### Core Components

**MyBluetooth Layer (`MyScale/MyBluetooth/`)**:
- `MyBluetooth.swift`: Protocol and implementation for Bluetooth management using AsyncBluetooth
- `Scale.swift`: Protocol for scale devices with measurement capabilities
- `EufyC1Scale.swift`: Concrete implementation for Eufy C1 scale with BLE characteristics parsing
- `BluetoothConnectable.swift`: Protocol for discoverable/connectable scale devices
- Uses AsyncBluetooth framework for modern async/await Bluetooth operations

**HealthKit Integration (`MyScale/MyHealthKit/`)**:
- `MyHealthKit.swift`: Main protocol and implementation for HealthKit operations
- `HealthKitAuthorization.swift`: Manages HealthKit permissions
- `BodyCharacteristics.swift`: Reads user's physical characteristics (height, age, biological sex)
- `HealthKitSample.swift`: Creates and saves health samples to HealthKit
- `HealthKitUnits.swift`: Handles preferred units for measurements

**Metrics Calculation (`MyScale/Model/`)**:
- `Metrics.swift`: Core algorithms for calculating BMI, body fat percentage, and lean body mass
- Uses proprietary formulas based on impedance, height, weight, age, and biological sex
- Supports localized units through HealthKit preferences

**SwiftUI Views (`MyScale/Views/`)**:
- `MainView.swift`: Root view with navigation handling
- `ConnectingView.swift`: Bluetooth scale discovery and connection
- `MeasureView.swift`: Live measurement display during weighing
- `ResultsView.swift`: Final measurement results with calculated metrics
- `MetricsView.swift`: Display component for body metrics
- Uses SwiftUI's `@Observable` macro for reactive state management

### App Flow
1. App launches and checks Bluetooth status
2. If Bluetooth is ready, scans for nearby Eufy scales
3. Connects to discovered scale and monitors for measurements
4. When measurement is received, calculates derived metrics using HealthKit body characteristics
5. Displays results and optionally saves to HealthKit

### Key Dependencies
- **AsyncBluetooth**: Modern async/await wrapper for Core Bluetooth
- **HealthKit**: Apple's health data framework
- **SwiftUI + Observation**: For reactive UI updates

### Development Notes
- Uses Swift 6.0 with strict concurrency enabled
- Targets iOS 18.1+ and macOS 14.7+
- App requires HealthKit and Bluetooth Central permissions
- Scale communication uses proprietary binary protocol (11-byte packets)
- Body fat calculations use gender/age-specific coefficients
- All async operations use proper error handling and cancellation support