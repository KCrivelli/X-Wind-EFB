//
//  Airline.swift
//  X-Wind EFB
//
//  Created by Kyle Crivelli on 7/20/26.
//
// Purpose:
// Defines supported airlines and the aircraft
// available for each airline.
//

import Foundation

enum Airline: String, CaseIterable, Codable, Identifiable {
    
    
    // #MARK: - Airline Initial Setup
    
    case skyWest
    
    var id: String {
        rawValue
    }
    
    // #MARK: - Airlines
    
    var displayName: String {
        switch self {
        case .skyWest:
            return "SkyWest Airlines"
            
        }
    }
    
    // #MARK: - Airline w/ Available Aircraft
    
    
    var availableFleets: [Fleet] {
        switch self {
        case .skyWest:
            return [
                .crj,
                .erj
            ]
        }
    }
    
    var availableAircraft: [AircraftType] {
        availableFleets.flatMap(\.availableAircraft)
    }
}

