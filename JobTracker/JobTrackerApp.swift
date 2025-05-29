//
//  JobTrackerApp.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import SwiftUI
import FirebaseCore


@main
struct JobTrackerApp: App {
    @StateObject private var viewModel = JobViewModel()
    @StateObject var authManager = AuthManager()

    init() {
        FirebaseApp.configure() // ✅ Initialize Firebase
    }
    var body: some Scene {
        WindowGroup {
            if let _ = authManager.user {
                         HomeView()
                             .environmentObject(authManager)
                             .environmentObject(viewModel)

                     } else {
                         LoginView() // or SignupView
                             .environmentObject(authManager)
                     }
               
        }
    }
}
