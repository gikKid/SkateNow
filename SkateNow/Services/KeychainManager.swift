import Foundation

class KeychainManager {
    enum KeychainError:Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(service:String,email:String,password:Data) throws {
        let query:[String:AnyObject] = [kSecClass as String:kSecClassGenericPassword,
                                        kSecAttrService as String:service as AnyObject,
                                        kSecAttrAccount as String: email as AnyObject,
                                        kSecValueData as String: password as AnyObject]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {throw KeychainError.duplicateEntry}
        guard status == errSecSuccess else {throw KeychainError.unknown(status)}
    }
    
    static func get(service:String,email:String) throws -> Data? {
        let query:[String:AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String:service as AnyObject,
            kSecAttrAccount as String:email as AnyObject,
            kSecReturnData as String:kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]
        
        var result:AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        print("Read status: \(status)")
        return result as? Data
    }
}
