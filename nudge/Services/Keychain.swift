//
//  Keychain.swift
//  NotesApp
//
//  Created by Sethar TyKun on 16/9/26.
//
import Foundation
import Security

enum Keychain {
    
// MARK: SAVE
    static func save(_ value: String, for key: String) {
        // Convert string to Data
        guard let data = value.data(using: .utf8) else {
            print("Keychain save failed: could not encode value")
            return
        }
        
        // Build address
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key,
        ]
        
        // Delete existing value at that address
        SecItemDelete(query as CFDictionary)
        
        // Copy address into mutable var and add one more key-value "kSecValue"
        var attributes = query
        attributes[kSecValueData as String] = data
        
        // Insert into keychain and receive an OSStatus
        let status = SecItemAdd(attributes as CFDictionary, nil)
        
        // If it's failed
        if status != errSecSuccess {
            print("Keychain save failed with status: \(status)")
        }
    }
    
// MARK: DELETE
    static func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete failed with status: \(status)")
        }
    }
    
// MARK: READ
    static func read(for key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            return nil
        }
        
        return result as? Data
    }

}


/*
 
 NOTE:
     SecItemAdd            → Create
     SecItemCopyMatching   → Read
     SecItemUpdate         → Update
     SecItemDelete         → Delete

 */
