//
//  JobDetailView.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import SwiftUI

struct JobDetailView: View {
    @State private var showEditSheet = false

    
    @Binding var job: JobApplication

    @EnvironmentObject var viewModel: JobViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirmation = false


    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(job.position)
                    .font(.title.bold())
                Text(job.company)
                    .font(.headline.weight(.medium))
                Text(job.location)
                    .font(.subheadline)
                
                HStack {
                    
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundColor(job.status.color(for: job.status))
                        
                    Text("Status : \(job.status)")
                     //   .fontWeight(.medium)
                }
                
                HStack {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundStyle(job.status.color(for: job.status))
                    
                    Text("Applied on:  \(job.appliedDate.formatted(date: .abbreviated, time: .omitted))")
                    
                 
                }
               //.background(.blue)
                
                if let link = job.linktoJob, let url = URL(string: link), !link.isEmpty {
                                    Link(destination: url) {
                                        Label(link, systemImage: "link")
                                    }
                                }
                
                if let notes = job.notes?.trimmingCharacters(in: .whitespacesAndNewlines), !notes.isEmpty {

                    VStack(alignment: .leading, spacing: 4) {
                    Text("Notes:")
                    Text(notes)
                    }
                    //.background(.blue)
                }
                
                
                if job.hiringManagerName != nil || job.hiringManagerEmail != nil {
                                       VStack(alignment: .leading, spacing: 4) {
                                           Text("Contact Details")
                                               .font(.headline)

                                           if let name = job.hiringManagerName, !name.isEmpty {
                                               Text(name)
                                           }

                                           if let email = job.hiringManagerEmail, !email.isEmpty {
                                               Text(email)
                                                   //.foregroundStyle(.blue)
                                           }
                                       }
                            }
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete Job", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.red)
                .font(.headline)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                Spacer()
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding()
            .navigationTitle("Detail View")
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                              showEditSheet = true
                          }
                }
            }
        }
        .alert("Are you sure you want to delete this job?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteJob()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showEditSheet) {
            AddJobView(existingJob: job)
                .environmentObject(viewModel)
        }
        
    }
    func deleteJob() {
        Task {
            viewModel.deleteJobs(job)
            if let index = viewModel.jobs.firstIndex(where: { $0.id == job.id }) {
                viewModel.jobs.remove(at: index)
            }
            dismiss()
        }
    }
       
}

#Preview {
    JobDetailView(job: .constant(
            JobApplication(
                id: "preview-id",
                company: "Abc",
                position: "XYZ",
                location: "CCC",
                appliedDate: Date(),
                status: .Applied
            )
        ))
        .environmentObject(JobViewModel())
}
