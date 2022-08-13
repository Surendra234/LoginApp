//
//  UserService.swift
//  LoginAppUsingScrollView
//
//  Created by Admin on 10/08/22.

import Foundation
import FirebaseAuth
import Firebase

class UserService {
    
    static func getUserInfo(completion: @escaping (UserDetail?) -> Void) {
        
        let myInformation = UserDefaults.standard
        
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { snapshot, err in
            
            if err != nil {
                print(err?.localizedDescription ?? "error")
                return
            }
            
            guard let snapshot = snapshot else { return}
            
            guard let doc = snapshot.data() else { return}
            
            guard let username = doc["username"] as? String else { return}
            
            guard let email = doc["email"] as? String else { return}
            
            guard let photoURl = doc["url"] as? String else { return}
            
            let userInfo = UserDetail(username: username, email: email, photoUrl: photoURl)
            
            myInformation.set(username, forKey: "name")
            myInformation.set(email, forKey: "email")
            
            completion(userInfo)
        }
    }
    
    func getUsername() -> String {
        
        guard let name = UserDefaults.standard.value(forKey: "name") as? String else { return "UserName"}
        return name
    }
    
    func getEmail() -> String {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return "Email_Id"}
        return email
    }
}
