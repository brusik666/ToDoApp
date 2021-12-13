//
//  ProtocolDatabaseManagerAvailable.swift
//  theApp1
//
//  Created by Brusik on 13.12.2021.
//

import Foundation
import UIKit

protocol DataBaseManagerAvailable {
    var dataBase: ToDoDataBase? { get }
}

extension DataBaseManagerAvailable {
    var dataBase: ToDoDataBase? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.dataBase
    }
}
