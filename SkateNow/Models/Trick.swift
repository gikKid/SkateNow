class Trick {
    var name:String
    var description:String?
    var imagesURL:[String]?
    
    init(name: String, description: String? = nil, imagesURL: [String]? = nil) {
        self.name = name
        self.description = description
        self.imagesURL = imagesURL
    }
}
