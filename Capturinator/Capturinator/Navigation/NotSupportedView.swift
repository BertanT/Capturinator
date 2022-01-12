//
//  NotSupportedView.swift
//  Capturinator
//
//  Created by Bertan on 11.01.2022.
//

import SwiftUI

struct NotSupportedView: View {
    var body: some View {
        ZStack(alignment: .center) {
            VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
            VStack {
                Label(title: {
                    Text((try? AttributedString(markdown: String(localized: "ObjectCaptureNotSupportedTitle", comment: "Label: Shown in the main window if the user's devie does not support Object Capture."))) ?? "MD Formatting Error!")
                }, icon: {
                    Image(systemName: "laptopcomputer.trianglebadge.exclamationmark")
                })
                    .font(.title)
                    .foregroundColor(.red)
                    .padding(2)
                Text((try? AttributedString(markdown: String(localized: "ObjectCaptureNotSupportedDescription", comment: "Label: Shown in the main window if the user's devie does not support Object Capture, more info about compatibility issue."))) ?? "MD Formatting Error!")
                    .font(.title3)
            }
        }
    }
}

struct NotSupportedView_Previews: PreviewProvider {
    static var previews: some View {
        NotSupportedView()
    }
}
