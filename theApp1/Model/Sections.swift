//
//  Sections.swift
//  theApp1
//
//  Created by Brusik on 07.12.2021.
//

import Foundation

enum Section {
    case uncompleteToDo, completeToDo
    
    var title: String {
        switch self {
        case .uncompleteToDo: return "To Do"
        case .completeToDo: return "Complete"
        }
    }
}
