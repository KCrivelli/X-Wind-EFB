//
//  MainCalculatorView.swift
//  X-Wind EFB
//
//  Purpose:
//  Assembles the main X-Wind dashboard.
//

import SwiftUI
import UIKit

extension UIApplication {
    
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}


struct MainCalculatorView: View {

    // MARK: - Application Model

    @EnvironmentObject
    private var userProfile: UserProfileStore

    @StateObject
    private var model = WindCalculationModel()


    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColor.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HeaderView()

                    if geometry.size.width >= 900 {
                        landscapeLayout
                    } else {
                        portraitLayout
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            synchronizeOperatingLimits()
        }
        .onChange(
            of: model.aircraftConfiguration
        ) { _, _ in
            synchronizeOperatingLimits()
        }
        .onChange(
            of: userProfile.selectedAircraft
        ) { _, _ in
            synchronizeOperatingLimits()
        }
        .onChange(
            of: userProfile.takeoffCrosswindLimit
        ) { _, _ in
            synchronizeOperatingLimits()
        }
        .onChange(
            of: userProfile.takeoffTailwindLimit
        ) { _, _ in
            synchronizeOperatingLimits()
        }
        .onChange(
            of: userProfile.landingCrosswindLimit
        ) { _, _ in
            synchronizeOperatingLimits()
        }
        .onChange(
            of: userProfile.landingTailwindLimit
        ) { _, _ in
            synchronizeOperatingLimits()
        }
    }
}


// MARK: - Landscape Layout

private extension MainCalculatorView {

    var landscapeLayout: some View {
        HStack(spacing: 0) {
            inputPanel
                .frame(width: 310)

            Divider()
                .overlay(AppColor.border)

            VStack(spacing: 8) {
                runwayPanel

                resultsPanel
            }
            .padding(8)
        }
    }
}


// MARK: - Portrait Layout

private extension MainCalculatorView {

    var portraitLayout: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                inputPanel

                runwayPanel
                    .frame(height: 700)

                resultsPanel
            }
            .padding(AppSpacing.medium)
        }
    }
}


// MARK: - Input Panel

private extension MainCalculatorView {

    var inputPanel: some View {
        InputPanelView(
            aircraftConfiguration:
                $model.aircraftConfiguration,

            runwayHeading:
                $model.runwayHeadingText,

            windDirection:
                $model.windDirectionText,

            windSpeed:
                $model.windSpeedText,

            crosswindLimit:
                model.crosswindLimit,

            tailwindLimit:
                model.tailwindLimit
        )
    }
}


// MARK: - Runway Panel

private extension MainCalculatorView {

    var runwayPanel: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            SectionHeader(title: "Runway")

            RunwayGraphic(
                runwayHeading:
                    model.runwayHeading ?? 0,

                windDirection:
                    model.windDirection ?? 0,

                headwindValue:
                    model.headwindValue,

                crosswindValue:
                    model.crosswindValue,

                crosswindDirection:
                    model.crosswindDirection
            )
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .padding(AppSpacing.panelPadding)
        .background(AppColor.background)
    }
}


// MARK: - Results Panel

private extension MainCalculatorView {

    var resultsPanel: some View {
        ResultsPanelView(
            headwindValue: model.headwindValue,
            crosswindValue: model.crosswindValue,
            crosswindDirection: model.crosswindDirection,
            crosswindLimit: model.crosswindLimit,
            tailwindLimit: model.tailwindLimit,
            limitStatus: model.limitStatus
        )
    }
}


// MARK: - Operating Limit Synchronization

private extension MainCalculatorView {

    func synchronizeOperatingLimits() {
        let configuration =
            model.aircraftConfiguration

        let crosswindLimit =
            userProfile.crosswindLimit(
                for: configuration
            )

        let tailwindLimit =
            userProfile.tailwindLimit(
                for: configuration
            )

        model.updateOperatingLimits(
            crosswind: crosswindLimit,
            tailwind: tailwindLimit
        )
    }
}


// MARK: - Preview

#Preview("Landscape Dashboard") {
    ContentView()
        .frame(
            width: 1194,
            height: 834
        )
}
