//
//  InputPanelView.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays the active aircraft, runway heading, wind,
//  and active operating limitations.
//

import SwiftUI


struct InputPanelView: View {

    // MARK: - Application Model

    @EnvironmentObject
    private var userProfile: UserProfileStore


    // MARK: - Bindings

    @Binding
    var aircraftConfiguration: AircraftConfiguration

    @Binding
    var runwayHeading: String

    @Binding
    var windDirection: String

    @Binding
    var windSpeed: String


    // MARK: - Operating Limits

    let crosswindLimit: Double

    let tailwindLimit: Double


    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.medium
            ) {
                aircraftHeader

                SectionHeader(
                    title: "Phase of Flight"
                )

                aircraftConfigurationInput

                Divider()
                    .overlay(AppColor.border)

                SectionHeader(
                    title: "Runway Heading"
                )

                runwayHeadingInput

                Divider()
                    .overlay(AppColor.border)

                windInputs

                Divider()
                    .overlay(AppColor.border)

                limitationDisplay
            }
            .padding(AppSpacing.panelPadding)
        }
        .background(AppColor.panel)
    }
}


// MARK: - Aircraft Header

private extension InputPanelView {

    var aircraftHeader: some View {
        VStack(spacing: AppSpacing.small) {
            Text(
                userProfile
                    .selectedAircraft?
                    .displayName
                ?? "No Aircraft Selected"
            )
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)

            Divider()
                .overlay(AppColor.border)
        }
    }
}


// MARK: - Aircraft Configuration

private extension InputPanelView {

    var aircraftConfigurationInput: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            
            Picker(
                "Aircraft Configuration",
                selection: $aircraftConfiguration
            ) {
                ForEach(
                    AircraftConfiguration.allCases
                ) { configuration in
                    Text(configuration.displayName)
                        .tag(configuration)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}


// MARK: - Runway Heading

private extension InputPanelView {

    var runwayHeadingInput: some View {
        InputField(
            title: "",
            placeholder: "000°",
            text: $runwayHeading,
            keyboard: .numberPad,
            unit:"°"
        )
    }
}


// MARK: - Wind Inputs

private extension InputPanelView {

    var windInputs: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            SectionHeader(
                title: "Wind Direction & Speed"
            )

            InputField(
                title:"",
                placeholder: "000°",
                text: $windDirection,
                keyboard: .numberPad,
                unit: "°"
            )

            InputField(
                title:"",
                placeholder: "00 kt",
                text: $windSpeed,
                keyboard: .numberPad,
                unit: "kt"
            )
        }
    }
}


// MARK: - Limitation Display

private extension InputPanelView {

    var limitationDisplay: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            SectionHeader(
                title: "Limitations"
            )

            limitationRow(
                title: "Crosswind Limit",
                value: crosswindLimit
            )

            limitationRow(
                title: "Tailwind Limit",
                value: tailwindLimit
            )

            Text(
                "\(aircraftConfiguration.displayName) limits"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    func limitationRow(
        title: String,
        value: Double
    ) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()

            Text(
                "\(value, specifier: "%.0f") kt"
            )
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .monospacedDigit()
        }
        .padding(
            .vertical,
            AppSpacing.small
        )
    }
}


// MARK: - Preview

#Preview("Input Panel") {
    InputPanelView(
        aircraftConfiguration:
            .constant(.takeoff),

        runwayHeading:
            .constant(""),

        windDirection:
            .constant(""),

        windSpeed:
            .constant(""),

        crosswindLimit:
            28,

        tailwindLimit:
            10
    )
    .environmentObject(
        UserProfileStore()
    )
    .frame(
        width: AppSize.sidebarWidth
    )
    .frame(
        height: 900
    )
    .preferredColorScheme(.dark)
}
