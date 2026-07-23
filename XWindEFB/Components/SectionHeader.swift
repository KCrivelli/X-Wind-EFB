//
//  SectionHeader.swift
//  X-Wind EFB
//
//  Purpose:
//  Displays a standardized section title.
//

import SwiftUI

struct SectionHeader: View {

    let title: String

    var body: some View {

        Text(title.uppercased())
            .font(AppFont.section)
            .tracking(1.5)
            .foregroundStyle(AppColor.accent)
            .frame(maxWidth: .infinity,
                   alignment: .leading)

    }

}

#Preview {

    VStack(alignment: .leading, spacing: 20) {

        SectionHeader(title: "Input")

        SectionHeader(title: "Runway")

        SectionHeader(title: "Results")

    }
    .padding()
    .background(AppColor.background)
    .preferredColorScheme(.dark)

}
