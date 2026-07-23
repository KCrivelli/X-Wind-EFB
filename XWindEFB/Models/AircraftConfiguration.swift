//
//  AircraftConfiguration.swift
//  X-Wind EFB
//
//  Created by Kyle Crivelli on 7/21/26.
//

import Foundation

enum AircraftConfiguration: String, CaseIterable, Identifiable {
    
    case takeoff
    case landing
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        switch self {
        
        case .takeoff:
            return "Takeoff"
            
        case .landing:
            return "Landing"
        }
    }
}
