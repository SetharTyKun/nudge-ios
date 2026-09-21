//
//  Support.swift
//  NotesApp
//
//  Created by Sethar TyKun on 24/8/26.
//
import Foundation

enum ViewState <T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}

