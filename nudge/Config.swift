//
//  Config.swift
//  NotesApp
//
//  Created by Sethar TyKun on 12/9/26.
//
import Foundation

enum Config {
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
              !url.isEmpty else {
            fatalError("APIBaseURL missing from Info.plist")
        }
        return url
    }()
    
    static let googleClientID: String = {
        guard let id = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String,
              !id.isEmpty else {
            fatalError("GIDClientID missing from Info.plist")
        }
        return id
    }()
}
