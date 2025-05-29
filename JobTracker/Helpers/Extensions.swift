//
//  Extensions.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import Foundation
import SwiftUICore

extension ApplicationStatus {
    func color(for status : ApplicationStatus) -> Color {
       switch status {
       case .Applied: return .blue
       case .Interview: return .orange
       case .Offer: return .green
       case .Rejected: return .red
           }
   }
}
