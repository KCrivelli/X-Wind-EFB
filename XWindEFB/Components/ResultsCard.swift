//
//  ResultCard.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays a single wind component.
//

import SwiftUI

struct ResultCard: View {

    let title: String
    let value: String
    let units: String
    let color: Color

    var body: some View {

        VStack(spacing: AppSpacing.small) {

            Text(title)
                .font(AppFont.caption)
                .foregroundStyle(AppColor.secondaryText)

            Text(value)
                .font(AppFont.largeNumber)
                .foregroundStyle(color)

            Text(units)
                .font(AppFont.caption)
                .foregroundStyle(AppColor.secondaryText)

        }
        .frame(maxWidth: .infinity)

    }

}

#Preview {

    HStack {

        ResultCard(
            title: "HEADWIND",
            value: "18",
            units: "kt",
            color: AppColor.success
        )

        ResultCard(
            title: "CROSSWIND",
            value: "11",
            units: "kt"
            ,
            color: AppColor.warning
        )

        ResultCard(
            title: "TAILWIND",
            value: "0",
            units: "kt",
            color: AppColor.secondaryText
        )

    }
    .padding()

    .background(AppColor.panel)

    .preferredColorScheme(.dark)

}
