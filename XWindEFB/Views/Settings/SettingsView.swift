//
//  SettingsView.swift
//  X-Wind EFB
//
//  Purpose:
//  Provides access to aircraft selection, operating-limit
//  overrides, support, legal information, and application details.
//

import SwiftUI


struct SettingsView: View {

    // MARK: - Environment

    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject
    private var userProfile: UserProfileStore


    // MARK: - Aircraft Selection

    @State
    private var airlineSelection: Airline = .skyWest

    @State
    private var fleetSelection: Fleet = .crj

    @State
    private var aircraftSelection: AircraftType = .crj700


    // MARK: - Limit Override State

    @State
    private var usesAircraftDefaults = true

    @State
    private var takeoffCrosswindText = ""

    @State
    private var takeoffTailwindText = ""

    @State
    private var landingCrosswindText = ""

    @State
    private var landingTailwindText = ""

    @State
    private var showInvalidLimitAlert = false

    @State
    private var showLimitsSavedConfirmation = false


    // MARK: - Focus

    @FocusState
    private var focusedLimitField: LimitField?


    // MARK: - Support

    private let supportEmail =
        "kcrivelliaviation@hotmail.com"


    // MARK: - Main Body

    var body: some View {
        NavigationStack {
            Form {
                profileSection

                limitationsSection

                supportSection

                legalSection

                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                keyboardToolbar

                ToolbarItem(
                    placement: .confirmationAction
                ) {
                    Button("Done") {
                        saveLimitsIfNeeded()
                        dismiss()
                    }
                }
            }
            .alert(
                "Invalid Limit",
                isPresented: $showInvalidLimitAlert
            ) {
                Button(
                    "OK",
                    role: .cancel
                ) { }
            } message: {
                Text(
                    """
                    Enter a valid number greater than or \
                    equal to zero for every operating limit.
                    """
                )
            }
            .alert(
                "Limits Saved",
                isPresented: $showLimitsSavedConfirmation
            ) {
                Button(
                    "OK",
                    role: .cancel
                ) { }
            } message: {
                Text(
                    """
                    The custom limits were saved for \
                    \(aircraftSelection.displayName).
                    """
                )
            }
            .onAppear {
                loadProfileSelections()
                loadLimitFields()
            }
        }
    }
}


// MARK: - Profile Section

private extension SettingsView {

    var profileSection: some View {
        Section {
            airlinePicker

            fleetPicker

            aircraftPicker
        } header: {
            Text("Profile")
        } footer: {
            Text(
                """
                Aircraft selections determine which default \
                operating limits are loaded by the calculator.
                """
            )
        }
    }


    var airlinePicker: some View {
        Picker(
            "Airline",
            selection: $airlineSelection
        ) {
            ForEach(Airline.allCases) { airline in
                Text(airline.displayName)
                    .tag(airline)
            }
        }
        .onChange(
            of: airlineSelection
        ) { _, newAirline in
            selectAirline(newAirline)
        }
    }


    var fleetPicker: some View {
        Picker(
            "Fleet",
            selection: $fleetSelection
        ) {
            ForEach(
                airlineSelection.availableFleets
            ) { fleet in
                Text(fleet.displayName)
                    .tag(fleet)
            }
        }
        .onChange(
            of: fleetSelection
        ) { _, newFleet in
            selectFleet(newFleet)
        }
    }


    var aircraftPicker: some View {
        Picker(
            "Aircraft",
            selection: $aircraftSelection
        ) {
            ForEach(
                fleetSelection.availableAircraft
            ) { aircraft in
                Text(aircraft.displayName)
                    .tag(aircraft)
            }
        }
        .onChange(
            of: aircraftSelection
        ) { _, newAircraft in
            userProfile.selectAircraft(
                newAircraft
            )

            loadLimitFields()
        }
    }
}


// MARK: - Limitations Section

private extension SettingsView {

    var limitationsSection: some View {
        Section {
            Toggle(
                "Use Aircraft Defaults",
                isOn: $usesAircraftDefaults
            )
            .onChange(
                of: usesAircraftDefaults
            ) { _, useDefaults in
                handleDefaultLimitToggle(
                    useDefaults
                )
            }

            if usesAircraftDefaults {
                defaultLimitsDisplay
            } else {
                customLimitsEditor
            }
        } header: {
            Text("Operating Limitations")
        } footer: {
            limitationFooter
        }
    }


    var defaultLimitsDisplay: some View {
        Group {
            limitDisplayRow(
                title: "Takeoff Crosswind",
                value:
                    aircraftSelection
                        .defaultTakeoffCrosswindLimit
            )

            limitDisplayRow(
                title: "Takeoff Tailwind",
                value:
                    aircraftSelection
                        .defaultTakeoffTailwindLimit
            )

            limitDisplayRow(
                title: "Landing Crosswind",
                value:
                    aircraftSelection
                        .defaultLandingCrosswindLimit
            )

            limitDisplayRow(
                title: "Landing Tailwind",
                value:
                    aircraftSelection
                        .defaultLandingTailwindLimit
            )
        }
    }


    var customLimitsEditor: some View {
        Group {
            limitInputRow(
                title: "Takeoff Crosswind",
                text: $takeoffCrosswindText,
                field: .takeoffCrosswind
            )

            limitInputRow(
                title: "Takeoff Tailwind",
                text: $takeoffTailwindText,
                field: .takeoffTailwind
            )

            limitInputRow(
                title: "Landing Crosswind",
                text: $landingCrosswindText,
                field: .landingCrosswind
            )

            limitInputRow(
                title: "Landing Tailwind",
                text: $landingTailwindText,
                field: .landingTailwind
            )

            Button {
                saveCustomLimits()
            } label: {
                Label(
                    "Save Custom Limits",
                    systemImage: "square.and.arrow.down"
                )
            }

            Button(
                role: .destructive
            ) {
                restoreAircraftDefaults()
            } label: {
                Label(
                    "Restore Aircraft Defaults",
                    systemImage: "arrow.counterclockwise"
                )
            }
        }
    }


    var limitationFooter: some View {
        Group {
            if usesAircraftDefaults {
                Text(
                    """
                    These values are the aircraft defaults \
                    currently stored in the application.
                    """
                )
            } else {
                Text(
                    """
                    Custom values apply only to \
                    \(aircraftSelection.displayName). \
                    Verify all limits against current company \
                    manuals and approved operating guidance.
                    """
                )
            }
        }
    }


    func limitDisplayRow(
        title: String,
        value: Double
    ) -> some View {
        HStack {
            Text(title)

            Spacer()

            Text(
                "\(formatted(value)) kt"
            )
            .foregroundStyle(.secondary)
            .monospacedDigit()
        }
    }


    func limitInputRow(
        title: String,
        text: Binding<String>,
        field: LimitField
    ) -> some View {
        HStack {
            Text(title)

            Spacer()

            TextField(
                "0",
                text: text
            )
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .monospacedDigit()
            .focused(
                $focusedLimitField,
                equals: field
            )
            .frame(width: 70)

            Text("kt")
                .foregroundStyle(.secondary)
        }
    }
}


// MARK: - Support Section

private extension SettingsView {

    var supportSection: some View {
        Section {
            Link(
                destination: supportEmailURL
            ) {
                Label(
                    "Report an Issue",
                    systemImage:
                        "exclamationmark.bubble"
                )
            }

            Link(
                destination:
                    recommendationEmailURL
            ) {
                Label(
                    "Send a Recommendation",
                    systemImage:
                        "lightbulb"
                )
            }
        } header: {
            Text("Support")
        } footer: {
            Text(
                """
                Your email application will open with a \
                prepared subject line and message template.
                """
            )
        }
    }


    var supportEmailURL: URL {
        makeEmailURL(
            subject:
                "X-Wind EFB Issue Report",
            body:
                """
                Please describe the issue below.

                Aircraft:
                Phase of flight:
                Runway heading:
                Wind direction:
                Wind speed:

                Description:


                Steps to reproduce:


                """
        )
    }


    var recommendationEmailURL: URL {
        makeEmailURL(
            subject:
                "X-Wind EFB Recommendation",
            body:
                """
                Please describe your recommendation below.

                Recommendation:


                How would this improve the application?


                """
        )
    }


    func makeEmailURL(
        subject: String,
        body: String
    ) -> URL {
        var components = URLComponents()

        components.scheme = "mailto"
        components.path = supportEmail

        components.queryItems = [
            URLQueryItem(
                name: "subject",
                value: subject
            ),

            URLQueryItem(
                name: "body",
                value: body
            )
        ]

        return components.url
            ?? URL(
                string:
                    "mailto:\(supportEmail)"
            )!
    }
}


// MARK: - Legal Section

private extension SettingsView {

    var legalSection: some View {
        Section {
            NavigationLink {
                DisclaimerView(
                    doNotShowAgain:
                        .constant(false),
                    isReviewMode: true
                ) {
                    // No action is needed in review mode.
                }
            } label: {
                Label(
                    "View Disclaimer",
                    systemImage:
                        "exclamationmark.shield"
                )
            }
        } header: {
            Text("Legal & Safety")
        } footer: {
            Text(
                """
                Review the operational disclaimer, user \
                responsibilities, and limitation of liability.
                """
            )
        }
    }
}


// MARK: - About Section

private extension SettingsView {

    var aboutSection: some View {
        Section("About") {
            NavigationLink {
                AboutView()
            } label: {
                Label(
                    "How the App Works",
                    systemImage:
                        "info.circle"
                )
            }
        }
    }
}


// MARK: - Toolbar

private extension SettingsView {

    @ToolbarContentBuilder
    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(
            placement: .keyboard
        ) {
            Spacer()

            Button("Done") {
                focusedLimitField = nil
            }
        }
    }
}


// MARK: - Aircraft Selection Logic

private extension SettingsView {

    func loadProfileSelections() {
        airlineSelection =
            userProfile.selectedAirline
            ?? .skyWest

        fleetSelection =
            userProfile.selectedFleet
            ?? airlineSelection
                .availableFleets
                .first
            ?? .crj

        aircraftSelection =
            userProfile.selectedAircraft
            ?? fleetSelection
                .availableAircraft
                .first
            ?? .crj700
    }


    func selectAirline(
        _ airline: Airline
    ) {
        userProfile.selectAirline(
            airline
        )

        guard let firstFleet =
            airline.availableFleets.first
        else {
            return
        }

        fleetSelection = firstFleet

        userProfile.selectFleet(
            firstFleet
        )

        guard let firstAircraft =
            firstFleet.availableAircraft.first
        else {
            return
        }

        aircraftSelection =
            firstAircraft

        userProfile.selectAircraft(
            firstAircraft
        )

        loadLimitFields()
    }


    func selectFleet(
        _ fleet: Fleet
    ) {
        userProfile.selectFleet(
            fleet
        )

        guard let firstAircraft =
            fleet.availableAircraft.first
        else {
            return
        }

        aircraftSelection =
            firstAircraft

        userProfile.selectAircraft(
            firstAircraft
        )

        loadLimitFields()
    }
}


// MARK: - Limit Logic

private extension SettingsView {

    func loadLimitFields() {
        takeoffCrosswindText =
            formatted(
                userProfile
                    .takeoffCrosswindLimit
            )

        takeoffTailwindText =
            formatted(
                userProfile
                    .takeoffTailwindLimit
            )

        landingCrosswindText =
            formatted(
                userProfile
                    .landingCrosswindLimit
            )

        landingTailwindText =
            formatted(
                userProfile
                    .landingTailwindLimit
            )

        usesAircraftDefaults =
            currentlyUsesAircraftDefaults
    }


    var currentlyUsesAircraftDefaults: Bool {
        approximatelyEqual(
            userProfile
                .takeoffCrosswindLimit,
            aircraftSelection
                .defaultTakeoffCrosswindLimit
        )
        &&
        approximatelyEqual(
            userProfile
                .takeoffTailwindLimit,
            aircraftSelection
                .defaultTakeoffTailwindLimit
        )
        &&
        approximatelyEqual(
            userProfile
                .landingCrosswindLimit,
            aircraftSelection
                .defaultLandingCrosswindLimit
        )
        &&
        approximatelyEqual(
            userProfile
                .landingTailwindLimit,
            aircraftSelection
                .defaultLandingTailwindLimit
        )
    }


    func handleDefaultLimitToggle(
        _ useDefaults: Bool
    ) {
        focusedLimitField = nil

        if useDefaults {
            restoreAircraftDefaults()
        } else {
            loadLimitFields()

            /*
             loadLimitFields detects that the current values
             match the defaults and turns the toggle back on.
             We explicitly return it to false so the fields
             become editable.
             */

            usesAircraftDefaults = false
        }
    }


    func saveLimitsIfNeeded() {
        guard !usesAircraftDefaults else {
            return
        }

        saveCustomLimits(
            showsConfirmation: false
        )
    }


    func saveCustomLimits(
        showsConfirmation: Bool = true
    ) {
        focusedLimitField = nil

        guard
            let takeoffCrosswind =
                parsedLimit(
                    takeoffCrosswindText
                ),

            let takeoffTailwind =
                parsedLimit(
                    takeoffTailwindText
                ),

            let landingCrosswind =
                parsedLimit(
                    landingCrosswindText
                ),

            let landingTailwind =
                parsedLimit(
                    landingTailwindText
                )
        else {
            showInvalidLimitAlert = true
            return
        }

        userProfile.updateTakeoffLimits(
            crosswind: takeoffCrosswind,
            tailwind: takeoffTailwind
        )

        userProfile.updateLandingLimits(
            crosswind: landingCrosswind,
            tailwind: landingTailwind
        )

        loadLimitFields()

        /*
         The values may happen to match the defaults exactly.
         If they do, they are functionally aircraft defaults.
         */

        usesAircraftDefaults =
            currentlyUsesAircraftDefaults

        if showsConfirmation {
            showLimitsSavedConfirmation =
                true
        }
    }


    func restoreAircraftDefaults() {
        focusedLimitField = nil

        userProfile
            .resetLimitsToAircraftDefaults()

        loadLimitFields()

        usesAircraftDefaults = true
    }


    func parsedLimit(
        _ text: String
    ) -> Double? {
        let cleanedText =
            text
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .replacingOccurrences(
                    of: ",",
                    with: "."
                )
                .replacingOccurrences(
                    of: "kt",
                    with: "",
                    options:
                        .caseInsensitive
                )
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        guard
            let value = Double(cleanedText),
            value >= 0,
            value.isFinite
        else {
            return nil
        }

        return value
    }


    func approximatelyEqual(
        _ firstValue: Double,
        _ secondValue: Double
    ) -> Bool {
        abs(
            firstValue - secondValue
        ) < 0.001
    }


    func formatted(
        _ value: Double
    ) -> String {
        value.formatted(
            .number
                .precision(
                    .fractionLength(
                        value.rounded() == value
                            ? 0
                            : 1
                    )
                )
        )
    }
}


// MARK: - Limit Field

private extension SettingsView {

    enum LimitField: Hashable {
        case takeoffCrosswind
        case takeoffTailwind
        case landingCrosswind
        case landingTailwind
    }
}


// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(
            UserProfileStore()
        )
}
