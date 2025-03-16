//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by jun on 4/6/24.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
