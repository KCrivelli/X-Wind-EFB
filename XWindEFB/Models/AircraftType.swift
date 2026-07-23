//
//  AircraftType.swift
//  X-Wind EFB
//
//  Created by Kyle Crivelli on 7/20/26.
//
//  Purpose:
//  Defines every aircraft type supported by the application,
//  including its default takeoff and landing wind limitations.
//

import Foundation

enum AircraftType: String, CaseIterable, Codable, Identifiable {

    case crj200
    case crj550
    case crj700
    case crj900
    case e170
    case e175


    // MARK: - Identification

    var id: String {
        rawValue
    }


    // MARK: - Display Names

    var displayName: String {
        switch self {

        case .crj200:
            return "CRJ-200"

        case .crj550:
            return "CRJ-550"

        case .crj700:
            return "CRJ-700"

        case .crj900:
            return "CRJ-900"

        case .e170:
            return "Embraer 170"

        case .e175:
            return "Embraer 175"
        }
    }

    var shortName: String {
        displayName
    }


    // MARK: - Default Takeoff Limits

    var defaultTakeoffCrosswindLimit: Double {
        switch self {

        case .crj200:
            return 27

        case .crj550:
            return 28

        case .crj700:
            return 28

        case .crj900:
            return 35

        case .e170:
            return 30

        case .e175:
            return 30
        }
    }

    var defaultTakeoffTailwindLimit: Double {
        switch self {

        case .crj200,
             .crj550,
             .crj700,
             .crj900,
             .e170,
             .e175:

            return 10
        }
    }


    // MARK: - Default Landing Limits

    var defaultLandingCrosswindLimit: Double {
        switch self {

        case .crj200:
            return 27

        case .crj550:
            return 30

        case .crj700:
            return 30

        case .crj900:
            return 32

        case .e170:
            return 30

        case .e175:
            return 30
        }
    }

    var defaultLandingTailwindLimit: Double {
        switch self {

        case .crj200,
             .crj550,
             .crj700,
             .crj900,
             .e170,
             .e175:

            return 10
        }
    }
}
