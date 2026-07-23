//
//  Fleet.swift
//  X-Wind EFB
//
//  Purpose:
//  Defines the aircraft fleets supported by the application and the aircraft available
//  within each fleet.

import Foundation

enum Fleet: String, CaseIterable, Codable, Identifiable {
    
    case crj
    case erj
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        switch self {
        case .crj:
            return "CRJ"
            
        case .erj:
            return "ERJ"
        }
    }
    var availableAircraft: [AircraftType] {
        switch self {
        case .crj:
            return [
                .crj200,
                .crj550,
                .crj700,
                .crj900
            ]
            
        case .erj:
            return [
                .e170,
                .e175
            ]
        }
    }
}
