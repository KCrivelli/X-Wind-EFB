//
//  OnboardingView.swift
//  X-Wind EFB
//
//  Purpose:
//  Guides the user through selecting an airline,
//  fleet, and aircraft.
//

import SwiftUI

struct OnboardingView: View {

    // MARK: - Application Model

    @EnvironmentObject
    private var userProfile: UserProfileStore


    // MARK: - Body

    var body: some View {
        ZStack {
            AppColor.background
                .ignoresSafeArea()

            VStack(spacing: AppSpacing.large) {
                Spacer()

                welcomeHeader

                selectionPanel

                continueButton

                Spacer()
            }
            .padding(AppSpacing.large)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .preferredColorScheme(.dark)
    }
}


// MARK: - Welcome Header

private extension OnboardingView {

    var welcomeHeader: some View {
        VStack(spacing: AppSpacing.small) {
            Text("Welcome to Crosswind Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(
                "Select your airline, fleet, and aircraft to configure your calculator."
            )
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }
}


// MARK: - Selection Panel

private extension OnboardingView {

    var selectionPanel: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            airlinePicker

            fleetPicker

            aircraftPicker
        }
        .padding(AppSpacing.panelPadding)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.panel)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColor.border, lineWidth: 1)
        }
    }
}


// MARK: - Airline Picker

private extension OnboardingView {

    var airlinePicker: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            Text("Airline")
                .font(.headline)
                .foregroundStyle(.white)

            Picker(
                "Select Airline",
                selection: airlineSelection
            ) {
                Text("Select an airline")
                    .tag(Airline?.none)

                ForEach(Airline.allCases) { airline in
                    Text(airline.displayName)
                        .tag(Airline?.some(airline))
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var airlineSelection: Binding<Airline?> {
        Binding(
            get: {
                userProfile.selectedAirline
            },
            set: { newAirline in
                guard let newAirline else {
                    return
                }

                userProfile.selectAirline(newAirline)

                if let firstFleet =
                    newAirline.availableFleets.first {

                    userProfile.selectFleet(firstFleet)

                    if let firstAircraft =
                        firstFleet.availableAircraft.first {

                        userProfile.selectAircraft(firstAircraft)
                    }
                }
            }
        )
    }
}


// MARK: - Fleet Picker

private extension OnboardingView {

    var fleetPicker: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            Text("Fleet")
                .font(.headline)
                .foregroundStyle(.white)

            Picker(
                "Select Fleet",
                selection: fleetSelection
            ) {
                Text("Select a fleet")
                    .tag(Fleet?.none)

                if let airline = userProfile.selectedAirline {
                    ForEach(
                        airline.availableFleets
                    ) { fleet in
                        Text(fleet.displayName)
                            .tag(Fleet?.some(fleet))
                    }
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .disabled(userProfile.selectedAirline == nil)
            .opacity(
                userProfile.selectedAirline == nil
                    ? 0.5
                    : 1
            )
        }
    }

    var fleetSelection: Binding<Fleet?> {
        Binding(
            get: {
                userProfile.selectedFleet
            },
            set: { newFleet in
                guard let newFleet else {
                    return
                }

                userProfile.selectFleet(newFleet)

                if let firstAircraft =
                    newFleet.availableAircraft.first {

                    userProfile.selectAircraft(firstAircraft)
                }
            }
        )
    }
}


// MARK: - Aircraft Picker

private extension OnboardingView {

    var aircraftPicker: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            Text("Aircraft")
                .font(.headline)
                .foregroundStyle(.white)

            Picker(
                "Select Aircraft",
                selection: aircraftSelection
            ) {
                Text("Select an aircraft")
                    .tag(AircraftType?.none)

                if let fleet = userProfile.selectedFleet {
                    ForEach(
                        fleet.availableAircraft
                    ) { aircraft in
                        Text(aircraft.displayName)
                            .tag(AircraftType?.some(aircraft))
                    }
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .disabled(userProfile.selectedFleet == nil)
            .opacity(
                userProfile.selectedFleet == nil
                    ? 0.5
                    : 1
            )
        }
    }

    var aircraftSelection: Binding<AircraftType?> {
        Binding(
            get: {
                userProfile.selectedAircraft
            },
            set: { newAircraft in
                guard let newAircraft else {
                    return
                }

                userProfile.selectAircraft(newAircraft)
            }
        )
    }
}


// MARK: - Continue Button

private extension OnboardingView {

    var continueButton: some View {
        Button {
            userProfile.completeSetup()
        } label: {
            Text("Continue")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .disabled(!userProfile.canCompleteSetup)
        .opacity(
            userProfile.canCompleteSetup
                ? 1
                : 0.5
        )
    }
}


// MARK: - Preview

#Preview {
    OnboardingView()
        .environmentObject(UserProfileStore())
}
