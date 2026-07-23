//
//  WindCalculator.swift
//  X-Wind EFB
//
//  Purpose:
//  Calculates headwind, tailwind, and crosswind components.
//

import Foundation

struct WindCalculationResult {

    let headwindComponent: Double
    let crosswindComponent: Double
    let crosswindDirection: CrosswindDirection

    var isHeadwind: Bool {
        headwindComponent >= 0
    }

    var headwindMagnitude: Double {
        abs(headwindComponent)
    }
}


enum CrosswindDirection: String {

    case left = "LEFT"
    case right = "RIGHT"
    case none = "NONE"
}


enum WindCalculator {

    static func calculate(
        runwayHeading: Double,
        windDirection: Double,
        windSpeed: Double
    ) -> WindCalculationResult {

        let angleDifference = normalizedAngle(
            windDirection - runwayHeading
        )

        let angleRadians = angleDifference * .pi / 180

        let headwindComponent =
            windSpeed * cos(angleRadians)

        let signedCrosswindComponent =
            windSpeed * sin(angleRadians)

        let crosswindDirection: CrosswindDirection

        if abs(signedCrosswindComponent) < 0.05 {
            crosswindDirection = .none
        } else if signedCrosswindComponent < 0 {
            crosswindDirection = .left
        } else {
            crosswindDirection = .right
        }

        return WindCalculationResult(
            headwindComponent: headwindComponent,
            crosswindComponent: abs(signedCrosswindComponent),
            crosswindDirection: crosswindDirection
        )
    }


    static func runwayHeading(
        from runwayIdentifier: String
    ) -> Double? {

        let runwayNumberText = runwayIdentifier.prefix {
            $0.isNumber
        }

        guard
            let runwayNumber = Double(runwayNumberText),
            (1...36).contains(runwayNumber)
        else {
            return nil
        }

        return runwayNumber * 10
    }


    private static func normalizedAngle(
        _ angle: Double
    ) -> Double {

        var result = angle
            .truncatingRemainder(dividingBy: 360)

        if result > 180 {
            result -= 360
        }

        if result < -180 {
            result += 360
        }

        return result
    }
}
