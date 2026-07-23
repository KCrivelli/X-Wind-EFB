//
//  ContentView.swift
//  X-Wind EFB
//
//  Created by Kyle Crivelli on 7/20/26.
//

import SwiftUI

struct ContentView: View {
    
@EnvironmentObject
    private var userProfile: UserProfileStore
    
    var body: some View {
        if userProfile.hasCompletedSetup {
            MainCalculatorView()
        } else {
            OnboardingView()
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(UserProfileStore())
}
