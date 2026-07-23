//
//  HeaderView.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays the active aircraft and provides access to settings.
//

import SwiftUI

struct HeaderView: View {

    // MARK: - Application Model

    @EnvironmentObject
    private var userProfile: UserProfileStore


    // MARK: - Local State

    @State
    private var isShowingSettings = false


    // MARK: - Body

    var body: some View {
        ZStack {
            Text("X-WIND EFB CALCULATOR")
                .font(.title2)
                .fontWeight(.semibold)
                .tracking(1)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            HStack {
                Spacer()

                settingsButton
            }
        }
        .padding(.horizontal, AppSpacing.medium)
        .padding(.vertical, AppSpacing.small)
        .background(AppColor.background)
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
                .environmentObject(userProfile)
        }
    }
}




// MARK: - Settings Button

private extension HeaderView {

    var settingsButton: some View {
        Button {
            isShowingSettings = true
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(
                    width: 44,
                    height: 44
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Settings")
    }
}


// MARK: - Preview

#Preview {
    HeaderView()
        .environmentObject(UserProfileStore())
        .background(AppColor.background)
}
