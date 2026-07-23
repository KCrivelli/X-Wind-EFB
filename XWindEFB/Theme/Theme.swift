//
//  Theme.swift
//  X-Wind EFB
//
//  Created by Kyle Crivelli.
//
//  Purpose:
//  Contains the application's design system.
//  All colors, fonts, spacing, and sizing live here so the
//  app has a consistent appearance.
//

import SwiftUI

// =======================================================
// MARK: - Colors
// =======================================================

enum AppColor {

    // Backgrounds

    static let background = Color(
        red: 0.035,
        green: 0.055,
        blue: 0.075
    )

    static let panel = Color(
        red: 0.055,
        green: 0.080,
        blue: 0.105
    )

    static let inputField = Color(
        red: 0.075,
        green: 0.105,
        blue: 0.135
    )

    // Runway

    static let runway = Color(
        red: 0.14,
        green: 0.16,
        blue: 0.18
    )

    static let runwayBorder = Color(
        red: 0.36,
        green: 0.41,
        blue: 0.46
    )

    // Accent

    static let accent = Color(
        red: 0.05,
        green: 0.55,
        blue: 0.95
    )

    // Status Colors

    static let success = Color.green

    static let caution = Color.yellow

    static let warning = Color.red

    // Text

    static let primaryText = Color.white

    static let secondaryText = Color(
        red: 0.65,
        green: 0.69,
        blue: 0.73
    )

    static let border = Color.white.opacity(0.12)
}

//
// MARK: - Fonts
//

enum AppFont {

    static let title = Font.system(
        size: 28,
        weight: .bold
    )

    static let section = Font.system(
        size: 14,
        weight: .bold
    )

    static let body = Font.system(
        size: 17,
        weight: .regular
    )

    static let label = Font.system(
        size: 15,
        weight: .medium
    )

    static let largeNumber = Font.system(
        size: 34,
        weight: .bold
    )

    static let runwayNumber = Font.system(
        size: 26,
        weight: .bold
    )

    static let caption = Font.system(
        size: 12,
        weight: .medium
    )
}

//
// MARK: - Spacing
//

enum AppSpacing {

    static let tiny: CGFloat = 6

    static let small: CGFloat = 10

    static let medium: CGFloat = 20

    static let large: CGFloat = 30

    static let panelPadding: CGFloat = 26

    static let cornerRadius: CGFloat = 12
}

//
// MARK: - Sizes
//

enum AppSize {

    static let sidebarWidth: CGFloat = 320

    static let headerHeight: CGFloat = 70

    static let resultsHeight: CGFloat = 120

    static let runwayWidth: CGFloat = 120
}

//
// MARK: - Animation
//

enum AppAnimation {

    static let standard = Animation.easeInOut(
        duration: 0.30
    )

    static let slow = Animation.easeInOut(
        duration: 0.60
    )
}
