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
        static let isDarkTheme = "darkTheme"
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
        static let skateboard = "Skateboard"
        static let scooter = "Scooter"
        static let bmx = "BMX"
        static let getStarted = "Get started"
        static let spots = "Spots"
        static let cancel = "Cancel"
        static let addSpot = "Add spot"
        static let generic = "Generic"
        static let fullInfo = "Full info"
        static let takePhoto = "Take photo"
        static let chooseFromPhotoGallery = "Choose from photo gallery"
        static let close = "Close"
        static let share = "Share"
        static let done = "Done"
    }
    
    enum Placeholders {
        static let password = "Write password"
        static let email = "Write email"
    }
    
    enum Colors {
        static let mainColor = "mainColor"
        static let gradientDarkGrey = UIColor(red: 239/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        static let gradientLightGrey = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
        static let firstLevelTrick = "firstLevelTrick"
        static let secondLevelTrick = "secondLevelTrick"
        static let thirdLevelTrick = "thirdLevelTrick"
    }
    
    enum Images {
        static let game = "gamecontroller.fill"
        static let study = "book.fill"
        static let map = "map.fill"
        static let person = "person.crop.circle"
        static let skateboard = "skateboard"
        static let scooter = "scooter"
        static let bmx = "bmx"
        static let downTriangle = "arrowtriangle.down.fill"
        static let profileDefault = "profileDefault"
        static let edit = "pencil"
        static let notEdit = "pencil.slash"
        static let share = "square.and.arrow.up"
        static let multiply = "multiply"
        static let starFill = "star.fill"
        static let emptyStar = "star"
        static let halfStar = "star.lefthalf.fill"
        static let square = "square"
        static let checkedSquare = "checkmark.square"
    }
    
    enum Identefiers {
        static let menuCollecionViewCell = "menuCell"
        static let spotMap = "spot"
        static let popOverCell = "popOverCell"
        static let imageSpotCollectionViewCell = "imageSpotCollectionCell"
        static let titleSpotCollectionViewCell = "titleSpotCollectionCell"
        static let preferredTypeSpotCollectionViewCell = "preferredTypeCollectionCell"
        static let fullInfoSpotCollectionViewCell = "fullInfoCollectionCell"
        static let buttonsSpotCollectionViewCell = "buttonsCollectionCell"
        static let studyCollectionViewCell = "studyCollectionCell"
    }
}
