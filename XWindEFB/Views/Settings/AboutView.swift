//
//  AboutView.swift
//  X-Wind EFB
//
//  Purpose:
//  Explains the application's calculation and limitation logic.
//

import SwiftUI


struct AboutView: View {

    var body: some View {
        List {
            overviewSection

            windComponentSection

            directionSection

            roundingSection

            limitationSection

            customLimitSection

            disclaimerSection

            versionSection
        }
        .navigationTitle("How the App Works")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Overview

private extension AboutView {

    var overviewSection: some View {
        Section("Overview") {
            Text(
                """
                X-Wind EFB calculates the headwind, \
                tailwind, and crosswind components produced \
                by the entered runway heading, wind \
                direction, and wind speed.
                """
            )

            Text(
                """
                The selected aircraft and phase of flight \
                determine which crosswind and tailwind \
                limits are used for the comparison.
                """
            )
        }
    }
}


// MARK: - Wind Components

private extension AboutView {

    var windComponentSection: some View {
        Section("Wind Component Calculation") {
            calculationRow(
                title: "Headwind or Tailwind",
                detail:
                    """
                    Wind speed multiplied by the cosine of \
                    the angle between the runway heading \
                    and wind direction.
                    """
            )

            calculationRow(
                title: "Crosswind",
                detail:
                    """
                    Wind speed multiplied by the sine of \
                    the angle between the runway heading \
                    and wind direction.
                    """
            )

            Text(
                """
                A positive longitudinal component is \
                displayed as a headwind. A negative \
                longitudinal component is displayed as a \
                tailwind.
                """
            )
        }
    }
}


// MARK: - Direction

private extension AboutView {

    var directionSection: some View {
        Section("Crosswind Direction") {
            Text(
                """
                The application identifies whether the \
                crosswind is coming from the left or right \
                side of the selected runway heading.
                """
            )

            Text(
                """
                Wind direction represents the direction \
                from which the wind is blowing.
                """
            )
        }
    }
}


// MARK: - Rounding

private extension AboutView {

    var roundingSection: some View {
        Section("Rounding") {
            Text(
                """
                Calculated wind components are rounded to \
                the nearest whole knot for display and \
                operating-limit comparison.
                """
            )

            Text(
                """
                For example, a calculated crosswind of \
                29.6 knots is displayed and compared as \
                30 knots.
                """
            )
        }
    }
}


// MARK: - Operating Limits

private extension AboutView {

    var limitationSection: some View {
        Section("Operating-Limit Comparison") {
            Text(
                """
                The rounded crosswind component is compared \
                with the selected crosswind limit.
                """
            )

            Text(
                """
                A tailwind component is compared with the \
                selected tailwind limit. Headwind values do \
                not use the tailwind limit.
                """
            )

            statusRow(
                icon: "checkmark.circle.fill",
                title: "Within Limits",
                description:
                    """
                    Neither the crosswind nor tailwind limit \
                    is exceeded.
                    """,
                color: .green
            )

            statusRow(
                icon:
                    "exclamationmark.triangle.fill",
                title: "Limit Exceeded",
                description:
                    """
                    One or both operating limits have been \
                    exceeded.
                    """,
                color: .red
            )
        }
    }
}


// MARK: - Custom Limits

private extension AboutView {

    var customLimitSection: some View {
        Section("Custom Operating Limits") {
            Text(
                """
                Aircraft defaults may be replaced with \
                custom takeoff and landing crosswind and \
                tailwind limits in Settings.
                """
            )

            Text(
                """
                Custom values are saved separately for each \
                aircraft. Selecting another aircraft loads \
                the saved values for that aircraft.
                """
            )

            Text(
                """
                Restoring aircraft defaults removes the \
                custom values for the currently selected \
                aircraft.
                """
            )
        }
    }
}


// MARK: - Disclaimer

private extension AboutView {

    var disclaimerSection: some View {
        Section("Important Notice") {
            Label {
                Text(
                    """
                    This application is an informational \
                    calculation aid. It does NOT replace \
                    approved aircraft manuals, company \
                    procedures, operational publications, \
                    dispatch guidance, or pilot judgment.
                    """
                )
            } icon: {
                Image(
                    systemName:
                        "exclamationmark.triangle.fill"
                )
                .foregroundStyle(.orange)
            }

            Text(
                """
                The user is responsible for confirming that \
                all aircraft limits and entered information \
                are current and correct before operational \
                use.
                """
            )
        }
    }
}


// MARK: - Version

private extension AboutView {

    var versionSection: some View {
        Section("Application") {
            HStack {
                Text("Version")

                Spacer()

                Text(appVersion)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Build")

                Spacer()

                Text(buildNumber)
                    .foregroundStyle(.secondary)
            }
        }
    }


    var appVersion: String {
        Bundle.main.object(
            forInfoDictionaryKey:
                "CFBundleShortVersionString"
        ) as? String ?? "1.0"
    }


    var buildNumber: String {
        Bundle.main.object(
            forInfoDictionaryKey:
                "CFBundleVersion"
        ) as? String ?? "1"
    }
}


// MARK: - Reusable Rows

private extension AboutView {

    func calculationRow(
        title: String,
        detail: String
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            Text(title)
                .fontWeight(.semibold)

            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 3)
    }


    func statusRow(
        icon: String,
        title: String,
        description: String,
        color: Color
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 3)
    }
}


// MARK: - Preview

#Preview {
    NavigationStack {
        AboutView()
    }
}
