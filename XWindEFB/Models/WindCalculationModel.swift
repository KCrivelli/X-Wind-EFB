//
//  WindCalculationModel.swift
//  X-Wind EFB
//
//  Purpose:
//  Stores the application's wind inputs, operating limits,
//  and calculated results.
//

import Foundation
import Combine


// MARK: - Wind Limit Status

enum WindLimitStatus {

    case invalidInput
    case withinLimits
    case crosswindLimitExceeded
    case tailwindLimitExceeded
    case bothLimitsExceeded

    var text: String {
        switch self {

        case .invalidInput:
            return "ENTER VALID DATA"

        case .withinLimits:
            return "WITHIN LIMITS"

        case .crosswindLimitExceeded:
            return "CROSSWIND LIMIT EXCEEDED"

        case .tailwindLimitExceeded:
            return "TAILWIND LIMIT EXCEEDED"

        case .bothLimitsExceeded:
            return "CROSSWIND & TAILWIND LIMITS EXCEEDED"
        }
    }
}


// MARK: - Wind Calculation Model

final class WindCalculationModel: ObservableObject {

    // MARK: - Published Input Values

    @Published
    var aircraftConfiguration: AircraftConfiguration = .takeoff

    @Published
    var runwayHeadingText: String = "" {
        didSet {
            calculate()
        }
    }

    @Published
    var windDirectionText: String = "" {
        didSet {
            calculate()
        }
    }

    @Published
    var windSpeedText: String = "" {
        didSet {
            calculate()
        }
    }


    // MARK: - Published Operating Limits

    @Published private(set)
    var crosswindLimit: Double = 30

    @Published private(set)
    var tailwindLimit: Double = 10


    // MARK: - Published Result Values

    @Published private(set)
    var headwindValue: Double = 0

    @Published private(set)
    var crosswindValue: Double = 0

    @Published private(set)
    var crosswindDirection: String = "NONE"


    // MARK: - Numeric Inputs

    var runwayHeading: Double? {
        guard
            let value = Double(runwayHeadingText),
            (0...360).contains(value)
        else {
            return nil
        }

        return value
    }

    var reciprocalHeading: Double {
        guard let runwayHeading else {
            return 0
        }

        let reciprocal = runwayHeading + 180

        return reciprocal >= 360
            ? reciprocal - 360
            : reciprocal
    }

    var windDirection: Double? {
        guard
            let value = Double(windDirectionText),
            (0...360).contains(value)
        else {
            return nil
        }

        return value
    }

    var windSpeed: Double? {
        guard
            let value = Double(windSpeedText),
            value >= 0
        else {
            return nil
        }

        return value
    }


    // MARK: - Component Values

    var isTailwind: Bool {
        headwindValue < 0
    }

    var headwindMagnitude: Double {
        max(0, headwindValue)
    }

    var tailwindMagnitude: Double {
        max(0, -headwindValue)
    }

    // Rounded vlaues used throughout the app
    
    var roundedCrosswindValue: Double {
        crosswindValue.rounded()
    }
    
    var roundedTailwindMagnitude: Double {
        tailwindMagnitude.rounded()
    }
    
    var crosswindExceedance: Double {
        max(
            0,
            roundedCrosswindValue - crosswindLimit
        )
    }
    
    var tailwindExceedance: Double {
        max(
            0,
            roundedTailwindMagnitude - tailwindLimit
        )
    }

    // MARK: - Limit Logic

    var isCrosswindLimitExceeded: Bool {
        roundedCrosswindValue > crosswindLimit
    }

    var isTailwindLimitExceeded: Bool {
        guard isTailwind else {
            return false
        }

        return roundedTailwindMagnitude > tailwindLimit
    }

    var limitStatus: WindLimitStatus {
        guard inputsAreValid else {
            return .invalidInput
        }

        switch (
            isCrosswindLimitExceeded,
            isTailwindLimitExceeded
        ) {

        case (false, false):
            return .withinLimits

        case (true, false):
            return .crosswindLimitExceeded

        case (false, true):
            return .tailwindLimitExceeded

        case (true, true):
            return .bothLimitsExceeded
        }
    }

    var calculationStatusText: String {
        limitStatus.text
    }

    var inputsAreValid: Bool {
        runwayHeading != nil &&
        windDirection != nil &&
        windSpeed != nil
    }


    // MARK: - Operating Limit Updates

    func updateOperatingLimits(
        crosswind: Double,
        tailwind: Double
    ) {
        guard
            crosswind >= 0,
            tailwind >= 0
        else {
            return
        }

        crosswindLimit = crosswind
        tailwindLimit = tailwind
    }


    // MARK: - Calculation

    func calculate() {
        guard
            let runwayHeading,
            let windDirection,
            let windSpeed
        else {
            resetResults()
            return
        }

        let result = WindCalculator.calculate(
            runwayHeading: runwayHeading,
            windDirection: windDirection,
            windSpeed: windSpeed
        )

        headwindValue =
            result.headwindComponent

        crosswindValue =
            result.crosswindComponent

        crosswindDirection =
            result.crosswindDirection.rawValue
    }

    func resetResults() {
        headwindValue = 0
        crosswindValue = 0
        crosswindDirection = "NONE"
    }


    // MARK: - Initialization

    init() {
        calculate()
    }
}
