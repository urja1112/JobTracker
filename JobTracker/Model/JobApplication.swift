//
//  JobApplication.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import Foundation


struct JobApplication : Identifiable,Codable,Hashable {
    var id  : String = UUID().uuidString
    var userId: String? // 🔥 Add this

    var company : String
    var position: String
    var location: String
    var appliedDate: Date
    var status: ApplicationStatus
    var notes: String?
    var linktoJob : String?
    var hiringManagerName: String?
     var hiringManagerEmail: String?
}
