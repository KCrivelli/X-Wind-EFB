//
//  ResultsPanelView.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays headwind, crosswind, and limitation status.
//

import SwiftUI

struct ResultsPanelView: View {

    let headwindValue: Double
    let crosswindValue: Double
    let crosswindDirection: String

    let crosswindLimit: Double
    let tailwindLimit: Double

    let limitStatus: WindLimitStatus

    private var isHeadwind: Bool {
        headwindValue >= 0
    }

    private var roundedWindValue: Double {
        abs(headwindValue).rounded()
    }

    private var roundedCrosswindValue: Double {
        crosswindValue.rounded()
    }

    private var crosswindExceedance: Double {
        max(
            0,
            roundedCrosswindValue - crosswindLimit
        )
    }

    private var tailwindExceedance: Double {
        guard !isHeadwind else {
            return 0
        }

        return max(
            0,
            roundedWindValue - tailwindLimit
        )
    }

    private var isCrosswindLimitExceeded: Bool {
        switch limitStatus {
        case .crosswindLimitExceeded,
             .bothLimitsExceeded:
            return true

        default:
            return false
        }
    }

    private var isTailwindLimitExceeded: Bool {
        switch limitStatus {
        case .tailwindLimitExceeded,
             .bothLimitsExceeded:
            return true

        default:
            return false
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            windResult

            separator

            crosswindResult

            separator

            statusResult
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(
            LinearGradient(
                colors: [
                    AppColor.panel,
                    AppColor.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    AppColor.border,
                    lineWidth: 1
                )
        }
    }
}


// MARK: - Headwind / Tailwind Result

private extension ResultsPanelView {

    var windResult: some View {
        VStack(spacing: 10) {
            Text(isHeadwind ? "HEADWIND" : "TAILWIND")
                .font(AppFont.caption)
                .tracking(1.2)
                .foregroundStyle(windResultColor)

            Text("\(formatted(roundedWindValue)) kt")
                .font(
                    .system(
                        size: 34,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(AppColor.primaryText)

            Text(windStatusText)
                .font(AppFont.caption)
                .tracking(1)
                .foregroundStyle(windResultColor)
        }
        .frame(maxWidth: .infinity)
    }

    var windStatusText: String {
        if isHeadwind {
            return "FAVORABLE"
        }

        if isTailwindLimitExceeded {
            return "LIMIT EXCEEDED"
        }

        return "WITHIN LIMIT"
    }

    var windResultColor: Color {
        if isHeadwind {
            return AppColor.success
        }

        if isTailwindLimitExceeded {
            return Color.red
        }

        return AppColor.success
    }
}


// MARK: - Crosswind Result

private extension ResultsPanelView {

    var crosswindResult: some View {
        VStack(spacing: 10) {
            Text("CROSSWIND")
                .font(AppFont.caption)
                .tracking(1.2)
                .foregroundStyle(
                    isCrosswindLimitExceeded
                        ? Color.red
                        : AppColor.warning
                )

            HStack(
                alignment: .firstTextBaseline,
                spacing: 8
            ) {
                Text("\(formatted(roundedCrosswindValue)) kt")
                    .font(
                        .system(
                            size: 34,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .monospacedDigit()

                Text(crosswindDirection)
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
            }
            .foregroundStyle(AppColor.primaryText)

            Text(
                isCrosswindLimitExceeded
                    ? "LIMIT EXCEEDED"
                    : "WITHIN LIMIT"
            )
            .font(AppFont.caption)
            .tracking(1)
            .foregroundStyle(
                isCrosswindLimitExceeded
                    ? Color.red
                    : AppColor.success
            )
        }
        .frame(maxWidth: .infinity)
    }
}


// MARK: - Status Result

private extension ResultsPanelView {

    var statusResult: some View {
        VStack(spacing: 8) {
            Text("STATUS")
                .font(AppFont.caption)
                .tracking(1.2)
                .foregroundStyle(statusColor)

            Image(systemName: statusIcon)
                .font(.system(size: 38))
                .foregroundStyle(statusColor)

            Text(statusTitle)
                .font(AppFont.caption)
                .fontWeight(.semibold)
                .tracking(0.7)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.65)
                .foregroundStyle(statusColor)
                .padding(.horizontal, 8)

            if shouldShowExceedanceDetails {
                VStack(spacing: 3) {
                    if isCrosswindLimitExceeded {
                        Text(
                            "Crosswind exceeds limit by " +
                            "\(formatted(crosswindExceedance)) kt"
                        )
                    }

                    if isTailwindLimitExceeded {
                        Text(
                            "Tailwind exceeds limit by " +
                            "\(formatted(tailwindExceedance)) kt"
                        )
                    }
                }
                .font(
                    .system(
                        size: 12,
                        weight: .medium,
                        design: .rounded
                    )
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(statusColor)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, 6)
            }
        }
        .frame(maxWidth: .infinity)
    }

    var shouldShowExceedanceDetails: Bool {
        isCrosswindLimitExceeded ||
        isTailwindLimitExceeded
    }

    var statusTitle: String {
        switch limitStatus {
        case .withinLimits:
            return "WITHIN LIMITS"

        case .invalidInput:
            return "INVALID INPUT"

        case .crosswindLimitExceeded:
            return "CROSSWIND LIMIT EXCEEDED"

        case .tailwindLimitExceeded:
            return "TAILWIND LIMIT EXCEEDED"

        case .bothLimitsExceeded:
            return "OPERATING LIMITS EXCEEDED"
        }
    }

    var statusColor: Color {
        switch limitStatus {
        case .withinLimits:
            return AppColor.success

        case .invalidInput:
            return AppColor.warning

        case .crosswindLimitExceeded,
             .tailwindLimitExceeded,
             .bothLimitsExceeded:
            return Color.red
        }
    }

    var statusIcon: String {
        switch limitStatus {
        case .withinLimits:
            return "checkmark.circle.fill"

        case .invalidInput:
            return "questionmark.circle.fill"

        case .crosswindLimitExceeded,
             .tailwindLimitExceeded,
             .bothLimitsExceeded:
            return "exclamationmark.triangle.fill"
        }
    }

    var separator: some View {
        Rectangle()
            .fill(AppColor.border)
            .frame(
                width: 1,
                height: 115
            )
    }
}


// MARK: - Formatting

private extension ResultsPanelView {

    func formatted(
        _ value: Double
    ) -> String {
        value.formatted(
            .number.precision(
                .fractionLength(0)
            )
        )
    }
}


// MARK: - Previews

#Preview("Within Limits") {
    ResultsPanelView(
        headwindValue: 18.2,
        crosswindValue: 28.4,
        crosswindDirection: "LEFT",
        crosswindLimit: 30,
        tailwindLimit: 10,
        limitStatus: .withinLimits
    )
    .padding()
    .background(AppColor.background)
    .preferredColorScheme(.dark)
}

#Preview("Crosswind Exceeded") {
    ResultsPanelView(
        headwindValue: 8.2,
        crosswindValue: 32.4,
        crosswindDirection: "LEFT",
        crosswindLimit: 30,
        tailwindLimit: 10,
        limitStatus: .crosswindLimitExceeded
    )
    .padding()
    .background(AppColor.background)
    .preferredColorScheme(.dark)
}

#Preview("Tailwind Exceeded") {
    ResultsPanelView(
        headwindValue: -12.3,
        crosswindValue: 8.4,
        crosswindDirection: "RIGHT",
        crosswindLimit: 30,
        tailwindLimit: 10,
        limitStatus: .tailwindLimitExceeded
    )
    .padding()
    .background(AppColor.background)
    .preferredColorScheme(.dark)
}

#Preview("Both Limits Exceeded") {
    ResultsPanelView(
        headwindValue: -12.3,
        crosswindValue: 33.4,
        crosswindDirection: "RIGHT",
        crosswindLimit: 30,
        tailwindLimit: 10,
        limitStatus: .bothLimitsExceeded
    )
    .padding()
    .background(AppColor.background)
    .preferredColorScheme(.dark)
}
