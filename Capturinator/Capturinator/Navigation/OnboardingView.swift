//
//  Onboarding.swift
//  Onboarding
//
//  Created by Bertan on 24.07.2021.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 90)
                .padding(.top)
            InclusiveGreeting(
                greetingMessage:
                    String(
                        localized: "OnboardingWelcome",
                        comment: "Text: Greets the user for the first time on the onboarding screen"),
                gradient: .sixColorGradient())
            VStack(alignment: .leading, spacing: 20) {
                OnboardingLabel(
                    title:
                        String(
                            localized: "TakePhotos",
                            comment: "Onboarding screen subtitle"),
                    description: String(
                        localized: "TakePhotosBody",
                        comment: "Onboarding screen text under take photos"),
                    systemImage: "camera.fill")
                OnboardingLabel(
                    title:
                        String(
                            localized: "ImportPhotos",
                            comment: "Onboarding screen subtitle"),
                    description:
                        String(
                            localized: "ImportPhotosBody",
                            comment: "Onboarding screen text under import photos"),
                    systemImage: "square.and.arrow.down.fill")
                OnboardingLabel(
                    title:
                        String(
                            localized: "Create",
                            comment: "Onboarding screen subtitle"),
                    description:
                        String(
                            localized: "CreateBody",
                            comment: "Onboarding screen text under create"),
                    systemImage: "wand.and.stars")
                OnboardingLabel(
                    title:
                        String(
                            localized: "OpenSource",
                            comment: "Onboarding screen subtitle"),
                    description: String(
                        localized: "OpenSourceBody",
                        comment: "Onboarding screen text under open source"),
                    systemImage: "chevron.left.forwardslash.chevron.right")

            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top)
            Spacer()
            Text("MadeWithLove", comment: "Message to be displayed at about this app window and onboarding screen")
                .roundedFont(.body)
            Spacer()
            Spacer()
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("StartCreating", comment: "Button: Dismisses the onboarding screen")
                    .padding(.horizontal)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .roundedFont(.title3)
            .keyboardShortcut(.defaultAction)
        }
        .frame(width: 550, height: 600)
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
