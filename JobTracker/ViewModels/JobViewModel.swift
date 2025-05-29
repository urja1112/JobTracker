//
//  JobViewModel.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import Foundation

@MainActor
class JobViewModel : ObservableObject {
    @Published var jobs : [JobApplication] = []
    @Published var isLoading = false

    private let firestore = FirestoreManager()
    
    func loadJobs() async {
        isLoading = true

        jobs = await firestore.fetchJobs()
        isLoading = false

    }
    func addJobs(_ job : JobApplication) {
        Task{await firestore.addJobs(job)}
    }
     
    func deleteJobs(_ job : JobApplication) {
        Task { await firestore.deleteJob(job)}
    }
    func updateJobs(_ job : JobApplication) {
        Task { await firestore.updateJob(job) }
    }
    
}
