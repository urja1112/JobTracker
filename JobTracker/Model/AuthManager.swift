//
//  UserManager.swift
//  JobTracker
//
//  Created by urja 💙 on 2025-05-09.
//
import FirebaseAuth
class AuthManager : ObservableObject {
    @Published var user: User?
    init() {
           Auth.auth().addStateDidChangeListener { _, user in
               self.user = user
           }
       }
    
    func signIn(email : String,password : String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.user = user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
    }
    
    func signUp(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.user = result.user
    }

    var userId: String? {
        user?.uid
    }
    
}
