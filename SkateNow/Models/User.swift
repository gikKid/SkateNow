import FirebaseAuth

struct User {
    var email:String
    var password:String
}

struct UserFirebase {
    let uid:String
    let email:String
    
    init(authData:FirebaseAuth.User) {
        self.uid = authData.uid
        self.email = authData.email ?? ""
    }
    
    init(uid: String, email: String) {
      self.uid = uid
      self.email = email
    }
}
