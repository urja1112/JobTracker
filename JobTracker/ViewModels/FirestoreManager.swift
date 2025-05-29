//
//  FirestoreManager.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-05.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


final class FirestoreManager {
    private var db = Firestore.firestore()
    func fetchJobs() async -> [JobApplication] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }
        
        do {
            let snapshot = try await db.collection("jobs")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            return snapshot.documents.compactMap { doc in
                try? doc.data(as: JobApplication.self)
            }
        } catch {
            print("❌ Error fetching jobs: \(error)")
            return []
        }
    }
    
    func addJobs(_ job: JobApplication) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        var newJob = job
        newJob.userId = userId
        
        let docRef = db.collection("jobs").document() // generates new doc with ID
        newJob.id = docRef.documentID // set that ID in the model

        do {
            try docRef.setData(from: newJob)
        } catch {
            print("❌ Error adding job: \(error)")
        }
    }
    func deleteJob(_ job : JobApplication) async {
        // let id = job.id
        do {
            try await db.collection("jobs").document(job.id).delete()
        } catch {
            print("❌ Error deleting job: \(error)")
        }
    }
    func updateJob(_ job : JobApplication) async {
        do {
            try db.collection("jobs").document(job.id).setData(from: job)
        } catch {
            print("❌ Error updating job: \(error)")

        }
    }
}
