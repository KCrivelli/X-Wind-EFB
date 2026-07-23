//
//  RunwayGraphic.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays a runway with correct visual wind-flow arrows.
//
//  Important:
//  - Selected runway heading is always shown at the near/bottom end.
//  - Reciprocal heading is shown at the far/top end.
//  - Headwind points toward the selected runway.
//  - Tailwind points away from the selected runway.
//  - Crosswind arrows show airflow direction.
//  - Aviation wind direction is converted from "from" direction
//    into the direction the airflow travels.
//

import SwiftUI

struct RunwayGraphic: View {

    let runwayHeading: Double

    var windDirection: Double
    var headwindValue: Double
    var crosswindValue: Double
    var crosswindDirection: String

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            let runwayHeight = min(
                size.height * 0.82,
                610
            )

            let runwayWidth = min(
                size.width * 0.27,
                240
            )

            ZStack {
                instrumentBackground

                runway(
                    width: runwayWidth,
                    height: runwayHeight
                )

                headwindIndicator(in: size)

                windIndicator(in: size)

                crosswindIndicator(in: size)
            }
            .frame(
                width: size.width,
                height: size.height
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }
}


// MARK: - Background

private extension RunwayGraphic {

    var instrumentBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            AppColor.panel,
                            AppColor.background
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RadialGradient(
                colors: [
                    Color.white.opacity(0.07),
                    Color.clear
                ],
                center: .center,
                startRadius: 25,
                endRadius: 430
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )

            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    AppColor.border.opacity(0.8),
                    lineWidth: 1
                )
        }
    }
}


// MARK: - Runway

private extension RunwayGraphic {

    func runway(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            runwayShadow(
                width: width,
                height: height
            )

            runwaySurface

            runwayEdgeLines(
                width: width,
                height: height
            )

            runwayMarkings(
                width: width,
                height: height
            )
        }
        .frame(
            width: width,
            height: height
        )
        .rotation3DEffect(
            .degrees(58),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.55
        )
    }

    func runwayShadow(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.black.opacity(0.85))
            .frame(
                width: width * 1.08,
                height: height * 1.02
            )
            .blur(radius: 17)
            .offset(y: 15)
    }

    var runwaySurface: some View {
        RoundedRectangle(cornerRadius: 7)
            .fill(
                LinearGradient(
                    colors: [
                        Color(
                            red: 0.25,
                            green: 0.26,
                            blue: 0.28
                        ),
                        Color(
                            red: 0.10,
                            green: 0.11,
                            blue: 0.13
                        ),
                        Color(
                            red: 0.18,
                            green: 0.19,
                            blue: 0.21
                        )
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                runwayTexture
                    .clipShape(
                        RoundedRectangle(cornerRadius: 7)
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(
                        Color.white.opacity(0.22),
                        lineWidth: 1
                    )
            }
    }

    var runwayTexture: some View {
        Canvas { context, size in
            let spacing: CGFloat = 17

            for yPosition in stride(
                from: CGFloat.zero,
                through: size.height,
                by: spacing
            ) {
                var path = Path()

                path.move(
                    to: CGPoint(
                        x: 0,
                        y: yPosition
                    )
                )

                path.addLine(
                    to: CGPoint(
                        x: size.width,
                        y: yPosition + 7
                    )
                )

                context.stroke(
                    path,
                    with: .color(
                        Color.white.opacity(0.018)
                    ),
                    lineWidth: 1
                )
            }
        }
    }

    func runwayEdgeLines(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        HStack {
            Rectangle()
                .fill(Color.white.opacity(0.94))
                .frame(width: 3)

            Spacer()

            Rectangle()
                .fill(Color.white.opacity(0.94))
                .frame(width: 3)
        }
        .padding(.horizontal, width * 0.055)
        .padding(.vertical, height * 0.02)
    }
}


// MARK: - Runway Markings

private extension RunwayGraphic {

    func runwayMarkings(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            centerline(
                width: width,
                height: height
            )

            VStack(spacing: 0) {
                runwayHeadingLabel(reciprocalHeading)
                    .rotationEffect(.degrees(180))

                Spacer()

                runwayHeadingLabel(runwayHeading)
            }
            .padding(.vertical, height * 0.055)
        }
    }

    func centerline(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        VStack(spacing: height * 0.024) {
            ForEach(0..<11, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(0.94))
                    .frame(
                        width: max(width * 0.025, 3),
                        height: height * 0.054
                    )
                    .opacity(
                        centerlineOpacity(for: index)
                    )
            }
        }
    }

    func centerlineOpacity(
        for index: Int
    ) -> Double {
        switch index {
        case 0, 1, 9, 10:
            return 0

        default:
            return 1
        }
    }

    func runwayHeadingLabel(
        _ heading: Double
    ) -> some View {
        Text(formattedHeading(heading))
            .font(
                .system(
                    size: 38,
                    weight: .bold,
                    design: .rounded
                )
            )
            .monospaced()
            .foregroundStyle(Color.white.opacity(0.97))
            .minimumScaleFactor(0.6)
            .shadow(
                color: Color.black.opacity(0.75),
                radius: 2,
                y: 2
            )
    }
}


// MARK: - Headwind / Tailwind

private extension RunwayGraphic {

    func headwindIndicator(
        in size: CGSize
    ) -> some View {
        let isHeadwind = headwindValue >= 0

        let indicatorColor = isHeadwind
            ? AppColor.success
            : Color.red

        return VStack(spacing: 8) {
            Text(isHeadwind ? "HEADWIND" : "TAILWIND")
                .font(AppFont.caption)
                .tracking(1.1)
                .foregroundStyle(indicatorColor)

            Text("\(formatted(abs(headwindValue))) kt")
                .font(
                    .system(
                        size: 19,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(indicatorColor)

            InstrumentArrow(
                color: indicatorColor,
                length: 72,
                lineWidth: 6
            )
            .rotationEffect(
                .degrees(
                    isHeadwind
                        ? 180
                        : 0
                )
            )
            .shadow(
                color: indicatorColor.opacity(0.48),
                radius: 9
            )
        }
        .position(
            x: size.width * 0.19,
            y: size.height * 0.48
        )
    }
}


// MARK: - Wind Direction

private extension RunwayGraphic {

    func windIndicator(
        in size: CGSize
    ) -> some View {
        VStack(spacing: 6) {
            Text("WIND")
                .font(AppFont.caption)
                .tracking(1.3)
                .foregroundStyle(AppColor.accent)

            Text("\(Int(windDirection.rounded()))°")
                .font(
                    .system(
                        size: 21,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(AppColor.primaryText)

            InstrumentArrow(
                color: AppColor.accent,
                length: 82,
                lineWidth: 7
            )
            .rotationEffect(
                .degrees(windArrowRotation)
            )
            .shadow(
                color: AppColor.accent.opacity(0.55),
                radius: 10
            )
        }
        .position(
            x: size.width * 0.80,
            y: size.height * 0.23
        )
    }

    var windArrowRotation: Double {
        /*
         The runway is drawn vertically with the selected runway
         pointing toward the bottom of the display.

         Aviation wind direction describes where the wind comes FROM.

         Example:
         Selected runway heading 240°.
         Wind 220° comes from 20° left of the runway heading.

         Therefore, the arrow should point down and to the right,
         showing airflow traveling from left toward the runway.
         */

        let relativeWindFromAngle = normalizedSignedAngle(
            windDirection - runwayHeading
        )

        return 180 + relativeWindFromAngle
    }
}


// MARK: - Crosswind

private extension RunwayGraphic {

    func crosswindIndicator(
        in size: CGSize
    ) -> some View {
        VStack(spacing: 9) {
            Text("CROSSWIND")
                .font(AppFont.caption)
                .tracking(1.1)
                .foregroundStyle(AppColor.warning)

            Text("\(formatted(crosswindValue)) kt")
                .font(
                    .system(
                        size: 19,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(AppColor.warning)

            InstrumentArrow(
                color: AppColor.warning,
                length: 92,
                lineWidth: 7
            )
            .rotationEffect(
                .degrees(crosswindArrowRotation)
            )
            .shadow(
                color: AppColor.warning.opacity(0.48),
                radius: 9
            )
        }
        .position(
            x: size.width * 0.81,
            y: size.height * 0.72
        )
    }

    var crosswindArrowRotation: Double {
        switch crosswindDirection.uppercased() {
        case "LEFT":
            // Wind comes from the left and travels to the right.
            return 90

        case "RIGHT":
            // Wind comes from the right and travels to the left.
            return -90

        default:
            return 0
        }
    }
}


// MARK: - Heading Helpers

private extension RunwayGraphic {

    var normalizedRunwayHeading: Double {
        let normalized = runwayHeading
            .truncatingRemainder(dividingBy: 360)

        return normalized >= 0
            ? normalized
            : normalized + 360
    }

    var reciprocalHeading: Double {
        let reciprocal = normalizedRunwayHeading + 180

        return reciprocal >= 360
            ? reciprocal - 360
            : reciprocal
    }

    func normalizedSignedAngle(
        _ angle: Double
    ) -> Double {
        var result = angle
            .truncatingRemainder(dividingBy: 360)

        if result > 180 {
            result -= 360
        }

        if result < -180 {
            result += 360
        }

        return result
    }

    func formattedHeading(
        _ heading: Double
    ) -> String {
        let roundedHeading = Int(heading.rounded()) % 360

        return String(
            format: "%03d°",
            roundedHeading
        )
    }
}


// MARK: - Formatting and Accessibility

private extension RunwayGraphic {

    var accessibilityDescription: String {
        """
        Runway heading \(formattedHeading(normalizedRunwayHeading)).
        Reciprocal heading \(formattedHeading(reciprocalHeading)).
        Wind \(Int(windDirection.rounded())) degrees.
        \(headwindValue >= 0 ? "Headwind" : "Tailwind") \
        \(formatted(abs(headwindValue))) knots.
        Crosswind \(formatted(crosswindValue)) knots \
        from the \(crosswindDirection.lowercased()).
        """
    }

    func formatted(
        _ value: Double
    ) -> String {
        value.formatted(
            .number.precision(
                .fractionLength(0...1)
            )
        )
    }
}


// MARK: - Arrow

private struct InstrumentArrow: View {

    let color: Color
    let length: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        VStack(spacing: -2) {
            Image(systemName: "arrowtriangle.up.fill")
                .font(
                    .system(
                        size: lineWidth * 3.7
                    )
                )
                .foregroundStyle(color)

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            color,
                            color.opacity(0.38)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    width: lineWidth,
                    height: length
                )
        }
        .fixedSize()
    }
}


// MARK: - Preview

#Preview("Heading 240 — Wind 220") {
    RunwayGraphic(
        runwayHeading: 240,
        windDirection: 220,
        headwindValue: 18.8,
        crosswindValue: 6.8,
        crosswindDirection: "LEFT"
    )
    .frame(
        width: 900,
        height: 700
    )
    .padding()
    .background(AppColor.background)
    .preferredColorScheme(.dark)
}
