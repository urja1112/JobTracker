//
//  AddJobView.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import SwiftUI

struct AddJobView: View {
    @State private var hiringManagerEmail : String = ""
    @State private var linkToJob : String = ""
    @State private var hiringManagerName : String = ""
    @State private var company : String = ""
    @State private var position : String = ""
    @State private var location : String = ""
    @State private var status : ApplicationStatus = ApplicationStatus.Applied
    @State private var date : Date = Date()
    @State private var notes : String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: JobViewModel
    @State private var showValidationAlert = false
    var existingJob: JobApplication? = nil

    var body: some View {
        NavigationStack {
           
            VStack {
              //  Spacer().frame(height: 12)
                Form{
                    Section {
                        TextField("Company", text: $company)
                            .textFieldStyle(.plain)
                            //.foregroundStyle(.black)
                        TextField("Position", text: $position)
                            .textFieldStyle(.plain)
                            //.foregroundStyle(.black)
                        TextField("Location", text: $location)
                            .textFieldStyle(.plain)
                           // .foregroundStyle(.black)
                    }
                    
                    Section {
                        DatePicker("Applied Date", selection: $date, in: ...Date(), displayedComponents: .date)
                        Picker("Status", selection: $status) {
                            ForEach(ApplicationStatus.allCases, id: \.self) { appstatus in
                                Text(appstatus.rawValue.capitalized)
                            }
                        }
                    }
                    Section {
                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Notes")
                                   // .foregroundColor(.gray)
                            }
                            
                            TextEditor(text: $notes)
                                .frame(height: 120)
                                .cornerRadius(8)
                        }
                       // .padding(.vertical, 8)
                       }
                    Section {
                        TextField("Link", text: $linkToJob)
                            .textFieldStyle(.plain)
                            //.foregroundStyle(.black)
                        TextField("Hiring Manager Name", text: $hiringManagerName)
                            .textFieldStyle(.plain)
                           // .foregroundStyle(.black)
                        TextField("Hiring Manager Email", text: $hiringManagerEmail)
                            .textFieldStyle(.plain)
                            //.foregroundStyle(.black)
                            .keyboardType(.emailAddress)
                    }
                }
               
                AddButton(action: {
                    if isFormValid() {
                        Task {
                            await saveData()
                        }
                    } else {
                        showValidationAlert = true

                    }
                }, image: "", title: "Save")
            }
            .onAppear {
                if let job = existingJob {
                    company = job.company
                    position = job.position
                    location = job.location
                    status = job.status
                    date = job.appliedDate
                    notes = job.notes ?? ""
                    linkToJob = job.linktoJob ?? ""
                    hiringManagerEmail = job.hiringManagerEmail ?? ""
                    hiringManagerName = job.hiringManagerName ?? ""
                }
            }
            .alert("Please fill all fields", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            }
            .navigationTitle(existingJob == nil ? "Add Job" : "Edit Job")

            
        }
    }
    
    func saveData() async {
        
        if var job = existingJob {
              job.company = company
              job.position = position
              job.location = location
              job.appliedDate = date
              job.status = status
              job.notes = notes
            job.hiringManagerEmail = hiringManagerEmail
            job.hiringManagerName = hiringManagerName
            job.linktoJob = linkToJob
            viewModel.updateJobs(job)
          } else {
              let newJob = JobApplication(
                  company: company,
                  position: position,
                  location: location,
                  appliedDate: date,
                  status: status,
                  notes: notes,
                  linktoJob : linkToJob,
                  hiringManagerName: hiringManagerName,
                  hiringManagerEmail: hiringManagerEmail
              )
              viewModel.addJobs(newJob)
          }
          await viewModel.loadJobs()
          dismiss()
    }
    
    func isFormValid() -> Bool {
        return !company.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !position.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    AddJobView()
}
