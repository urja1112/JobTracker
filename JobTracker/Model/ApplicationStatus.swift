//
//  ApplicationStatus.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import Foundation
enum ApplicationStatus : String,CaseIterable,Codable,Identifiable {
    var id: String { rawValue }

    
    case Applied, Interview, Offer, Rejected

}
