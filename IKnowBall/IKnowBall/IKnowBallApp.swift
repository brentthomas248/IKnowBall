//
//  IKnowBallApp.swift
//  IKnowBall
//
//  Created by Brent Showalter on 12/8/25.
//

import SwiftUI
import IKnowBallFeature

@main
struct IKnowBallApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
    }
}
