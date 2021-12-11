//
//  Sections.swift
//  theApp1
//
//  Created by Brusik on 07.12.2021.
//

import Foundation

enum Section: CaseIterable, Hashable {
    case uncompleteToDo, completeToDo
    
    var title: String? {
        switch self {
        case .uncompleteToDo: return nil
        case .completeToDo: return "Complete"
        }
    }
}
