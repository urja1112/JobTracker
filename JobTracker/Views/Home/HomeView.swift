//
//  HomeView.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @State private var jobToEdit: JobApplication?
    @State private var showEditSheet = false
    @EnvironmentObject var viewModel: JobViewModel
    @State private var selectedJob: String?
    @EnvironmentObject var authManager: AuthManager


   // @State private var selectedJob: JobApplication? = nil
    @State private var selectedStatus : ApplicationStatus? = nil
    var filteredJobs: [JobApplication] {
        viewModel.jobs.filter { job in
            let matchesStatus = selectedStatus == nil || job.status == selectedStatus
            let matchesSearch = searchText.isEmpty ||
                job.company.localizedCaseInsensitiveContains(searchText) ||
                job.position.localizedCaseInsensitiveContains(searchText) ||
            job.location.localizedCaseInsensitiveContains(searchText)
            
            return matchesStatus && matchesSearch
        }
    }
    var sortedJobs : [JobApplication] {
        filteredJobs.sorted(by: { $0.appliedDate > $1.appliedDate })
    }
   

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("loading data")
                }
               else if viewModel.jobs.isEmpty{
                    EmptyStateView(message: "No Jobs Found.")
                        .padding(30)
                }
                else {
                    Picker("Status", selection: $selectedStatus) {
                        Text("All").tag(ApplicationStatus?.none)
                        ForEach(ApplicationStatus.allCases, id: \.self) { status in
                            Text(status.rawValue.capitalized).tag(Optional(status))
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
               
                        List {
                            Text("You Applied for \(filteredJobs.count) Job.")
                                .bold()
                        
                            ForEach(sortedJobs) { job in
                                JobCardView(job: job) {
                                    jobToEdit = job
                                    showEditSheet.toggle()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedJob = job.id
                                }
                                  
                            }
                            .onDelete(perform: deleteItem)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                }
                Spacer()
                NavigationLink(destination: AddJobView()) {
                    Label("Add Job", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                        .bold()
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .contentShape(Rectangle())
                }
                .padding(.horizontal,30)
            
            }
            .onAppear {
                if viewModel.jobs.isEmpty {
                    Task {
                        await viewModel.loadJobs()
                    }
                }
            }
           // .padding(.horizontal)
            .searchable(text: $searchText, prompt: "Search Jobs")
            .navigationTitle("Job Tracker")
            .navigationDestination(item: $selectedJob) { jobId in
                if let index = viewModel.jobs.firstIndex(where: { $0.id == jobId }) {
                    JobDetailView(job: $viewModel.jobs[index])
                }
            }
            .sheet(item: $jobToEdit) { job in
                AddJobView(existingJob: job)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        do {
                            try authManager.signOut()
                        } catch {
                            print("❌ Error signing out: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let jobToDelete = sortedJobs[index]
            
            // 1. Delete from Firestore
            viewModel.deleteJobs(jobToDelete)
            
            // 2. Also remove from in-memory list to reflect UI instantly
            if let indexInJobs = viewModel.jobs.firstIndex(where: { $0.id == jobToDelete.id }) {
                viewModel.jobs.remove(at: indexInJobs)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(JobViewModel())
}
