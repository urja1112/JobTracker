//
//  SharedViews.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import SwiftUI


struct EmptyStateView : View {
    var message : String
    var body: some View {
        VStack(spacing: 16){
            Image(systemName: "tray")
                .resizable()
                .frame(width: 80,height: 80)
                .foregroundStyle(.gray)
            Text(message)
                .font(.headline)
                .foregroundStyle(.gray)
            
        }
        .padding()
    }
}

struct AddButton : View {
    var action: () -> Void
      var image: String
      var title: String

      var body: some View {
          Button {
              action()
          } label: {
              Label(title, systemImage: image)
                  .frame(maxWidth: .infinity)
                  .bold()
                  .padding()
                  .foregroundStyle(.white)
                  .background(.blue)
                  .clipShape(RoundedRectangle(cornerRadius: 12))
                  .contentShape(Rectangle())
                  .padding(.horizontal, 30)
          }
      }
}

struct StatusTagView : View {
    var status : ApplicationStatus
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.headline)
        
            .padding(.horizontal,8)
            .padding(.vertical,4)
            .background(status.color(for: status))
            .foregroundStyle(.white)
            .cornerRadius(8)
        
    }
   
}


#Preview {
   // SharedViews()
    var action : () -> Void

    EmptyStateView(message: "Please Enter a Job to begin")
    AddButton(action: {
        print("Save tapped")
    }, image: "square.and.arrow.down", title: "Save")
    StatusTagView(status: .Rejected)
}
