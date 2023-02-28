import Foundation
import UIKit

enum Resources {
    
    enum Keys {
        static let isSignIn = "isSignIn"
        static let email = "EmailKey"
        static let password = "passwordKey"
        static let uid = "uidKey"
        static let service = "Firebase"
        static let isChoosenTransport = "transportKey"
    }
    
    enum Titles {
        static let errorTitle = "Error"
        static let confirmAlertActionTitle = "OK"
        static let signIn = "Sign in"
        static let signUp = "Sign up"
        static let create = "Create"
        static let skateNow = "SkateNow"
        static let unvalidPassword = "Password is unvalid, it must be more 6 characters!"
        static let unvalidEmail = "Email is unvalid"
        static let success = "Success"
        static let successRegisteringUser = "User was created!"
        static let confirm = "Confirm"
        static let game = "Game"
        static let study = "Study"
        static let map = "Map"
        static let menu = "Menu"
        static let profile = "Profile"
        static let scateboard = "Scateboard"
        static let scooter = "Scooter"
        static let bmx = "BMX"
        static let getStarted = "Get started"
    }
    
    enum Placeholders {
        static let password = "Write password"
        static let email = "Write email"
    }
    
    enum Colors {
        static let mainColor = "mainColor"
    }
    
    enum Images {
        static let game = "gamecontroller.fill"
        static let study = "book.fill"
        static let map = "map.fill"
        static let person = "person.crop.circle"
        static let scateboard = "skateboard"
        static let scooter = "scooter"
        static let bmx = "bmx"
        static let downTriangle = "arrowtriangle.down.fill"
    }
    
    enum Identefiers {
        static let menuCollecionViewCell = "menuCell"
    }
}
