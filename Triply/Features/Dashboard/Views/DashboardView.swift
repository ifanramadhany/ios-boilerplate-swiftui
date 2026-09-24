//
//  DashboardView.swift
//  Triply
//
//  Created by Ifan Ramadhany on 22/09/2026.
//

import SwiftUI

struct DashboardView: View {
    private enum Layout {
        static let cardHeight: CGFloat = 130
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to Triply").font(.largeTitle.bold())

                Text("Plan and organize your next adventure.").foregroundStyle(
                    .appPrimary
                )
                HStack(spacing: 12) {
                    Image(systemName: "sparkles").foregroundStyle(.orange)
                    Text("Plan something memorable.").font(
                        .body.weight(.medium)
                    )
                    Spacer()

                }.padding(16).background(Color.orange.opacity(0.12)).clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

                Text("Quick Actions").font(.largeTitle)

                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "bookmark").foregroundStyle(.orange)
                            .font(.system(size: 20, weight: .bold))
                        Text("Saved trips").font(
                            .body.weight(.medium)
                        )
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(
                        16
                    )
                    .frame(
                        height: Layout.cardHeight,
                        alignment: .center
                    ).background(Color.orange.opacity(0.12))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "safari").foregroundStyle(.orange)
                            .font(.system(size: 20, weight: .bold))
                        Text("Explore places").font(
                            .body.weight(.medium)
                        )

                    }.frame(maxWidth: .infinity, alignment: .leading).padding(
                        16
                    )
                    .frame(
                        height: Layout.cardHeight,
                        alignment: .center
                    ).background(Color.orange.opacity(0.12))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
            }.frame(maxWidth: .infinity, alignment: .leading).padding(20)
        }
    }
}

#Preview {
    DashboardView()
}
