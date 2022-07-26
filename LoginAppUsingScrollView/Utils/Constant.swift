//
//  Constant.swift
//  LoginAppUsingScrollView
//
//  Created by Admin on 01/08/22.
//

import Foundation

struct Constant {
    
    class HomeView {
        static let homedashBoard = ContainerControllerVC()
    }
    
    class LoginView {
        static let loginPage = LoginVC()
    }
    
    class Archive {
        static let archiveNote = ArchiveNotesVC()
    }
    
    class Delete {
        static let deleteNote = DeletedNotesVC()
    }
    
    class ReminderOption {
        static let reminderNote = ReminderVC()
    }
}


// Mark : Reminder

struct Reminder {
    
    let date: Date
}
