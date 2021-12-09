//
//  DiffableDataSource.swift
//  theApp1
//
//  Created by Brusik on 02.12.2021.
//

import Foundation
import UIKit

class ToDoTableViewDiffableDataSource: UITableViewDiffableDataSource<String, ToDo> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
