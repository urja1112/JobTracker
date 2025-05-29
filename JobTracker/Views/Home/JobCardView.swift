//
//  JobCardView.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import SwiftUI

struct JobCardView: View {
    let job : JobApplication
    let onEdit: () -> Void

    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading,spacing: 6){
                Text(job.position)
                    .font(.headline)
               
                Text(job.company)
                    .font(.subheadline)
                
                Text(job.location)
                    .font(.caption)
                
               
            }
            Spacer()
            
            StatusTagView(status: job.status)
         
            Button(action: {
                onEdit()
            }) {
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(8)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    JobCardView(job: JobApplication(company: "Apple", position: "iOS Developer", location: "Calgary", appliedDate: Date(), status: ApplicationStatus.Applied), onEdit: {  print("Edit tapped")
})
}
