//
//  LaunchGateView.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays the disclaimer before allowing access to the
//  application's existing launch and onboarding flow.
//

import SwiftUI


struct LaunchGateView: View {

    // MARK: - Persistent State

    @AppStorage(
        "hasAcceptedOperationalDisclaimer"
    )
    private var hasAcceptedDisclaimer =
        false


    // MARK: - Session State

    @State
    private var hasContinuedThisSession =
        false

    @State
    private var doNotShowAgain =
        true


    // MARK: - Body

    var body: some View {
        Group {
            if hasAcceptedDisclaimer ||
                hasContinuedThisSession {

                ContentView()

            } else {
                DisclaimerView(
                    doNotShowAgain:
                        $doNotShowAgain
                ) {
                    continueIntoApplication()
                }
            }
        }
    }
}


// MARK: - Actions

private extension LaunchGateView {

    func continueIntoApplication() {
        if doNotShowAgain {
            hasAcceptedDisclaimer = true
        }

        withAnimation(
            .easeInOut(duration: 0.3)
        ) {
            hasContinuedThisSession = true
        }
    }
}


// MARK: - Preview

#Preview {
    LaunchGateView()
        .environmentObject(
            UserProfileStore()
        )
}
