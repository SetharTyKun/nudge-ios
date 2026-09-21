//
//  SecureVault.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/9/26.
//

import Foundation
import Security
import LocalAuthentication

enum SecureVault {
    
    // MARK: Save (Face ID)
    static func save(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else {
            print("SecureVault save failed: could not convert value into Data")
            return
        }
        
        guard let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence,
            nil,
        ) else {
            print("SecureVault save failed: could not create access control")
            return
        }
        
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(deleteQuery as CFDictionary)
        
        
        let saveQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key,
            kSecAttrAccessControl as String: accessControl,
            kSecValueData as String: data,
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("SecureVault save failed")
            return
        }
    }
    
    static func read(for key: String, reason: String) -> Data? {
        let context = LAContext()
        context.localizedReason = reason
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecUseAuthenticationContext as String: context,
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("SecureVault read failed: \(status)")
            return nil
        }
        
        return result as? Data
    }
    
    static func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.app.default",
            kSecAttrAccount as String: key,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            print("SecureVault delete failed: \(status)")
            return
        }
    }

}
