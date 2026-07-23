//
//  UserProfileStore.swift
//  X-Wind EFB
//
//  Purpose:
//  Stores the user's selected airline, fleet, aircraft,
//  aircraft-specific operating limits, and setup status.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class UserProfileStore: ObservableObject {

    // MARK: - Published Profile Values

    @Published private(set) var selectedAirline: Airline?
    @Published private(set) var selectedFleet: Fleet?
    @Published private(set) var selectedAircraft: AircraftType?


    // MARK: - Published Aircraft Limits

    @Published private(set)
    var takeoffCrosswindLimit: Double

    @Published private(set)
    var takeoffTailwindLimit: Double

    @Published private(set)
    var landingCrosswindLimit: Double

    @Published private(set)
    var landingTailwindLimit: Double


    // MARK: - Setup Status

    @Published private(set)
    var hasCompletedSetup: Bool


    // MARK: - UserDefaults Keys

    private enum StorageKey {

        static let selectedAirline =
            "selectedAirline"

        static let selectedFleet =
            "selectedFleet"

        static let selectedAircraft =
            "selectedAircraft"

        static let hasCompletedSetup =
            "hasCompletedSetup"

        static func takeoffCrosswindLimit(
            for aircraft: AircraftType
        ) -> String {
            "aircraft.\(aircraft.rawValue).takeoffCrosswindLimit"
        }

        static func takeoffTailwindLimit(
            for aircraft: AircraftType
        ) -> String {
            "aircraft.\(aircraft.rawValue).takeoffTailwindLimit"
        }

        static func landingCrosswindLimit(
            for aircraft: AircraftType
        ) -> String {
            "aircraft.\(aircraft.rawValue).landingCrosswindLimit"
        }

        static func landingTailwindLimit(
            for aircraft: AircraftType
        ) -> String {
            "aircraft.\(aircraft.rawValue).landingTailwindLimit"
        }
    }


    // MARK: - Fallback Values

    private enum AppDefault {

        static let crosswindLimit: Double = 30
        static let tailwindLimit: Double = 10
    }


    // MARK: - Storage

    private let defaults: UserDefaults


    // MARK: - Initialization

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        takeoffCrosswindLimit =
            AppDefault.crosswindLimit

        takeoffTailwindLimit =
            AppDefault.tailwindLimit

        landingCrosswindLimit =
            AppDefault.crosswindLimit

        landingTailwindLimit =
            AppDefault.tailwindLimit

        if let savedAirlineRawValue = defaults.string(
            forKey: StorageKey.selectedAirline
        ) {
            selectedAirline = Airline(
                rawValue: savedAirlineRawValue
            )
        } else {
            selectedAirline = nil
        }

        if let savedFleetRawValue = defaults.string(
            forKey: StorageKey.selectedFleet
        ) {
            selectedFleet = Fleet(
                rawValue: savedFleetRawValue
            )
        } else {
            selectedFleet = nil
        }

        if let savedAircraftRawValue = defaults.string(
            forKey: StorageKey.selectedAircraft
        ) {
            selectedAircraft = AircraftType(
                rawValue: savedAircraftRawValue
            )
        } else {
            selectedAircraft = nil
        }

        hasCompletedSetup = defaults.bool(
            forKey: StorageKey.hasCompletedSetup
        )

        validateSavedProfile()
        loadLimitsForSelectedAircraft()
    }
}


// MARK: - Airline Selection

extension UserProfileStore {

    func selectAirline(
        _ airline: Airline
    ) {
        selectedAirline = airline

        defaults.set(
            airline.rawValue,
            forKey: StorageKey.selectedAirline
        )

        validateFleetForSelectedAirline()
    }
}


// MARK: - Fleet Selection

extension UserProfileStore {

    func selectFleet(
        _ fleet: Fleet
    ) {
        guard let selectedAirline else {
            return
        }

        guard selectedAirline.availableFleets.contains(
            fleet
        ) else {
            return
        }

        selectedFleet = fleet

        defaults.set(
            fleet.rawValue,
            forKey: StorageKey.selectedFleet
        )

        validateAircraftForSelectedFleet()
    }
}


// MARK: - Aircraft Selection

extension UserProfileStore {

    func selectAircraft(
        _ aircraft: AircraftType
    ) {
        guard let selectedFleet else {
            return
        }

        guard selectedFleet.availableAircraft.contains(
            aircraft
        ) else {
            return
        }

        selectedAircraft = aircraft

        defaults.set(
            aircraft.rawValue,
            forKey: StorageKey.selectedAircraft
        )

        loadLimitsForSelectedAircraft()
    }
}


// MARK: - Active Operating Limits

extension UserProfileStore {

    func crosswindLimit(
        for configuration: AircraftConfiguration
    ) -> Double {
        switch configuration {

        case .takeoff:
            return takeoffCrosswindLimit

        case .landing:
            return landingCrosswindLimit
        }
    }

    func tailwindLimit(
        for configuration: AircraftConfiguration
    ) -> Double {
        switch configuration {

        case .takeoff:
            return takeoffTailwindLimit

        case .landing:
            return landingTailwindLimit
        }
    }
}


// MARK: - Takeoff Limit Updates

extension UserProfileStore {

    func updateTakeoffCrosswindLimit(
        _ limit: Double
    ) {
        guard
            let selectedAircraft,
            limit >= 0
        else {
            return
        }

        takeoffCrosswindLimit = limit

        defaults.set(
            limit,
            forKey: StorageKey.takeoffCrosswindLimit(
                for: selectedAircraft
            )
        )
    }

    func updateTakeoffTailwindLimit(
        _ limit: Double
    ) {
        guard
            let selectedAircraft,
            limit >= 0
        else {
            return
        }

        takeoffTailwindLimit = limit

        defaults.set(
            limit,
            forKey: StorageKey.takeoffTailwindLimit(
                for: selectedAircraft
            )
        )
    }
}


// MARK: - Landing Limit Updates

extension UserProfileStore {

    func updateLandingCrosswindLimit(
        _ limit: Double
    ) {
        guard
            let selectedAircraft,
            limit >= 0
        else {
            return
        }

        landingCrosswindLimit = limit

        defaults.set(
            limit,
            forKey: StorageKey.landingCrosswindLimit(
                for: selectedAircraft
            )
        )
    }

    func updateLandingTailwindLimit(
        _ limit: Double
    ) {
        guard
            let selectedAircraft,
            limit >= 0
        else {
            return
        }

        landingTailwindLimit = limit

        defaults.set(
            limit,
            forKey: StorageKey.landingTailwindLimit(
                for: selectedAircraft
            )
        )
    }
}


// MARK: - Combined Limit Updates

extension UserProfileStore {

    func updateTakeoffLimits(
        crosswind: Double,
        tailwind: Double
    ) {
        guard
            crosswind >= 0,
            tailwind >= 0
        else {
            return
        }

        updateTakeoffCrosswindLimit(crosswind)
        updateTakeoffTailwindLimit(tailwind)
    }

    func updateLandingLimits(
        crosswind: Double,
        tailwind: Double
    ) {
        guard
            crosswind >= 0,
            tailwind >= 0
        else {
            return
        }

        updateLandingCrosswindLimit(crosswind)
        updateLandingTailwindLimit(tailwind)
    }
}


// MARK: - Reset Aircraft Limits

extension UserProfileStore {

    func resetLimitsToAircraftDefaults() {
        guard let selectedAircraft else {
            return
        }

        takeoffCrosswindLimit =
            selectedAircraft
                .defaultTakeoffCrosswindLimit

        takeoffTailwindLimit =
            selectedAircraft
                .defaultTakeoffTailwindLimit

        landingCrosswindLimit =
            selectedAircraft
                .defaultLandingCrosswindLimit

        landingTailwindLimit =
            selectedAircraft
                .defaultLandingTailwindLimit

        defaults.removeObject(
            forKey: StorageKey.takeoffCrosswindLimit(
                for: selectedAircraft
            )
        )

        defaults.removeObject(
            forKey: StorageKey.takeoffTailwindLimit(
                for: selectedAircraft
            )
        )

        defaults.removeObject(
            forKey: StorageKey.landingCrosswindLimit(
                for: selectedAircraft
            )
        )

        defaults.removeObject(
            forKey: StorageKey.landingTailwindLimit(
                for: selectedAircraft
            )
        )
    }
}


// MARK: - Setup Status

extension UserProfileStore {

    var canCompleteSetup: Bool {
        selectedAirline != nil &&
        selectedFleet != nil &&
        selectedAircraft != nil
    }

    func completeSetup() {
        guard canCompleteSetup else {
            return
        }

        hasCompletedSetup = true

        defaults.set(
            true,
            forKey: StorageKey.hasCompletedSetup
        )
    }

    func resetProfile() {
        selectedAirline = nil
        selectedFleet = nil
        selectedAircraft = nil

        takeoffCrosswindLimit =
            AppDefault.crosswindLimit

        takeoffTailwindLimit =
            AppDefault.tailwindLimit

        landingCrosswindLimit =
            AppDefault.crosswindLimit

        landingTailwindLimit =
            AppDefault.tailwindLimit

        hasCompletedSetup = false

        defaults.removeObject(
            forKey: StorageKey.selectedAirline
        )

        defaults.removeObject(
            forKey: StorageKey.selectedFleet
        )

        defaults.removeObject(
            forKey: StorageKey.selectedAircraft
        )

        defaults.set(
            false,
            forKey: StorageKey.hasCompletedSetup
        )
    }
}


// MARK: - Limit Loading

private extension UserProfileStore {

    func loadLimitsForSelectedAircraft() {
        guard let selectedAircraft else {
            takeoffCrosswindLimit =
                AppDefault.crosswindLimit

            takeoffTailwindLimit =
                AppDefault.tailwindLimit

            landingCrosswindLimit =
                AppDefault.crosswindLimit

            landingTailwindLimit =
                AppDefault.tailwindLimit

            return
        }

        takeoffCrosswindLimit = savedLimit(
            forKey: StorageKey.takeoffCrosswindLimit(
                for: selectedAircraft
            ),
            defaultValue:
                selectedAircraft
                    .defaultTakeoffCrosswindLimit
        )

        takeoffTailwindLimit = savedLimit(
            forKey: StorageKey.takeoffTailwindLimit(
                for: selectedAircraft
            ),
            defaultValue:
                selectedAircraft
                    .defaultTakeoffTailwindLimit
        )

        landingCrosswindLimit = savedLimit(
            forKey: StorageKey.landingCrosswindLimit(
                for: selectedAircraft
            ),
            defaultValue:
                selectedAircraft
                    .defaultLandingCrosswindLimit
        )

        landingTailwindLimit = savedLimit(
            forKey: StorageKey.landingTailwindLimit(
                for: selectedAircraft
            ),
            defaultValue:
                selectedAircraft
                    .defaultLandingTailwindLimit
        )
    }

    func savedLimit(
        forKey key: String,
        defaultValue: Double
    ) -> Double {
        guard defaults.object(forKey: key) != nil else {
            return defaultValue
        }

        let savedValue = defaults.double(
            forKey: key
        )

        guard savedValue >= 0 else {
            return defaultValue
        }

        return savedValue
    }
}


// MARK: - Validation

private extension UserProfileStore {

    func validateSavedProfile() {
        guard let selectedAirline else {
            clearInvalidFleet()
            hasCompletedSetup = false
            return
        }

        guard let selectedFleet else {
            clearInvalidAircraft()
            hasCompletedSetup = false
            return
        }

        guard selectedAirline.availableFleets.contains(
            selectedFleet
        ) else {
            clearInvalidFleet()
            hasCompletedSetup = false
            return
        }

        guard let selectedAircraft else {
            hasCompletedSetup = false
            return
        }

        guard selectedFleet.availableAircraft.contains(
            selectedAircraft
        ) else {
            clearInvalidAircraft()
            hasCompletedSetup = false
            return
        }
    }

    func validateFleetForSelectedAirline() {
        guard
            let selectedAirline,
            let selectedFleet
        else {
            return
        }

        guard selectedAirline.availableFleets.contains(
            selectedFleet
        ) else {
            clearInvalidFleet()
            return
        }
    }

    func validateAircraftForSelectedFleet() {
        guard
            let selectedFleet,
            let selectedAircraft
        else {
            return
        }

        guard selectedFleet.availableAircraft.contains(
            selectedAircraft
        ) else {
            clearInvalidAircraft()
            return
        }
    }

    func clearInvalidFleet() {
        selectedFleet = nil

        defaults.removeObject(
            forKey: StorageKey.selectedFleet
        )

        clearInvalidAircraft()
    }

    func clearInvalidAircraft() {
        selectedAircraft = nil

        defaults.removeObject(
            forKey: StorageKey.selectedAircraft
        )

        loadLimitsForSelectedAircraft()
    }
}
