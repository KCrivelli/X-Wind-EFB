//
//  DisclaimerView.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays the application's operational disclaimer before
//  the user accesses the calculator. It can also display the
//  disclaimer in review mode from Settings.
//

import SwiftUI


struct DisclaimerView: View {

    // MARK: - Properties

    @Binding
    var doNotShowAgain: Bool

    let isReviewMode: Bool

    let continueAction: () -> Void


    // MARK: - Initialization

    init(
        doNotShowAgain: Binding<Bool>,
        isReviewMode: Bool = false,
        continueAction: @escaping () -> Void
    ) {
        self._doNotShowAgain =
            doNotShowAgain

        self.isReviewMode =
            isReviewMode

        self.continueAction =
            continueAction
    }


    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                header

                introduction

                notAReplacementSection

                userResponsibilitySection

                acknowledgment

                footer
            }
            .padding(.horizontal, 28)
            .padding(.top, 28)
            .padding(.bottom, 40)
        }
        .safeAreaInset(
            edge: .bottom
        ) {
            if !isReviewMode {
                bottomControls
            }
        }
        .background(
            AppColor.background
                .ignoresSafeArea()
        )
        .navigationTitle(
            isReviewMode
                ? "Disclaimer"
                : ""
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Header

private extension DisclaimerView {

    var header: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Image(
                systemName:
                    "exclamationmark.triangle.fill"
            )
            .font(
                .system(size: 44)
            )
            .foregroundStyle(
                AppColor.warning
            )

            Text("Welcome to X-Wind EFB")
                .font(
                    .system(
                        size: 32,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    AppColor.primaryText
                )

            Text("IMPORTANT NOTICE")
                .font(AppFont.caption)
                .fontWeight(.bold)
                .tracking(1.5)
                .foregroundStyle(
                    AppColor.warning
                )
        }
    }
}


// MARK: - Introduction

private extension DisclaimerView {

    var introduction: some View {
        disclaimerCard {
            Text(
                """
                X-Wind EFB is intended to assist flight \
                crews in calculating headwind, tailwind, \
                and crosswind components.
                """
            )

            Text(
                """
                Calculations are based solely on the runway \
                heading, wind direction, wind speed, \
                selected aircraft, phase of flight, and \
                operating limitations entered or stored \
                within the application.
                """
            )

            Text(
                """
                X-Wind EFB is not an approved operational \
                or performance application and must not be \
                used as the sole source for an operational \
                decision.
                """
            )
            .fontWeight(.semibold)
        }
    }
}


// MARK: - Not a Replacement

private extension DisclaimerView {

    var notAReplacementSection: some View {
        disclaimerSection(
            title:
                "This Application Does NOT Replace",
            systemImage:
                "doc.text.magnifyingglass"
        ) {
            disclaimerItem(
                "Approved aircraft manuals and documentation"
            )

            disclaimerItem(
                "Company policies, procedures, and limitations"
            )

            disclaimerItem(
                "Dispatch releases and operational guidance"
            )

            disclaimerItem(
                "NOTAMs, ATIS, AWOS, or other current weather information"
            )

            disclaimerItem(
                "Pilot judgment and operational decision-making"
            )
        }
    }
}


// MARK: - User Responsibility

private extension DisclaimerView {

    var userResponsibilitySection: some View {
        disclaimerSection(
            title:
                "The User Is Responsible For",
            systemImage:
                "person.crop.circle.badge.checkmark"
        ) {
            disclaimerItem(
                "Verifying that all entered data is correct"
            )

            disclaimerItem(
                "Confirming that aircraft operating limitations are current"
            )

            disclaimerItem(
                "Using current company and manufacturer guidance"
            )

            disclaimerItem(
                "Determining whether conditions are suitable for operation"
            )

            disclaimerItem(
                "Making all final operational decisions"
            )
        }
    }
}


// MARK: - Acknowledgment

private extension DisclaimerView {

    var acknowledgment: some View {
        disclaimerSection(
            title:
                "Acknowledgment & Limitation of Liability",
            systemImage:
                "shield.lefthalf.filled"
        ) {
            Text(
                """
                X-Wind EFB is provided solely as an informational \
                calculation aid to assist flight crews in determining \
                headwind, tailwind, and crosswind components.
                """
            )

            Text(
                """
                This application is not approved for operational \
                flight planning or aircraft performance calculations \
                and must not be used as a substitute for approved \
                aircraft manuals, company procedures, current \
                operational information, or sound pilot judgment.
                """
            )

            Text(
                """
                By selecting "Acknowledge and Continue," you confirm \
                that you understand and accept that you are solely \
                responsible for verifying all entered information, \
                confirming current aircraft limitations and company \
                guidance, and making all operational decisions.
                """
            )

            Divider()

            Text("Limitation of Liability")
                .font(.headline)

            Text(
                """
                X-Wind EFB is provided "as is" without any express \
                or implied warranties regarding its accuracy, \
                reliability, availability, or fitness for a \
                particular purpose.
                """
            )

            Text(
                """
                To the fullest extent permitted by applicable law, \
                the developer of X-Wind EFB shall not be liable \
                for any direct, indirect, incidental, consequential, \
                or special damages, including but not limited to \
                personal injury, property damage, financial loss, \
                operational delays, or any other loss arising from \
                the use of, inability to use, or reliance upon this \
                application or its calculations.
                """
            )

            Text(
                """
                Your continued use of this application constitutes \
                your acknowledgment and acceptance of these terms \
                and your agreement that all flight planning and \
                operational decisions remain solely your \
                responsibility.
                """
            )
            .fontWeight(.semibold)
        }
    }
}


// MARK: - Footer

private extension DisclaimerView {

    var footer: some View {
        VStack(spacing: 5) {
            Text("X-Wind EFB")
                .fontWeight(.semibold)

            Text(
                "Version \(appVersion) (\(buildNumber))"
            )

            Text("© 2026 Kyle Crivelli")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
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


// MARK: - Bottom Controls

private extension DisclaimerView {

    var bottomControls: some View {
        VStack(spacing: 14) {
            Toggle(
                isOn: $doNotShowAgain
            ) {
                Text("Don't show this again")
                    .fontWeight(.medium)
            }
            .tint(
                AppColor.success
            )

            Button {
                continueAction()
            } label: {
                Text("Acknowledge and Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(
                .borderedProminent
            )
        }
        .padding(.horizontal, 28)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(
            .ultraThinMaterial
        )
    }
}


// MARK: - Reusable Components

private extension DisclaimerView {

    func disclaimerCard<
        Content: View
    >(
        @ViewBuilder
        content: () -> Content
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 14,
            content: content
        )
        .font(.body)
        .foregroundStyle(
            AppColor.primaryText
        )
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(20)
        .background {
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                AppColor.panel
            )
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: 16
            )
            .stroke(
                AppColor.border,
                lineWidth: 1
            )
        }
    }


    func disclaimerSection<
        Content: View
    >(
        title: String,
        systemImage: String,
        @ViewBuilder
        content: () -> Content
    ) -> some View {
        disclaimerCard {
            Label(
                title,
                systemImage: systemImage
            )
            .font(.headline)
            .foregroundStyle(
                AppColor.primaryText
            )

            VStack(
                alignment: .leading,
                spacing: 12,
                content: content
            )
        }
    }


    func disclaimerItem(
        _ text: String
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(
                systemName:
                    "checkmark.circle.fill"
            )
            .foregroundStyle(
                AppColor.warning
            )
            .padding(.top, 2)

            Text(text)
                .foregroundStyle(
                    AppColor.primaryText
                )
        }
    }
}


// MARK: - Preview

#Preview("Initial Disclaimer") {
    NavigationStack {
        DisclaimerView(
            doNotShowAgain:
                .constant(false)
        ) {
            print("Continue selected")
        }
    }
    .preferredColorScheme(.dark)
}


#Preview("Settings Review") {
    NavigationStack {
        DisclaimerView(
            doNotShowAgain:
                .constant(false),
            isReviewMode: true
        ) {
            // No action is needed in review mode.
        }
    }
    .preferredColorScheme(.dark)
}
