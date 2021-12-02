//
//  DiffableDataSource.swift
//  theApp1
//
//  Created by Brusik on 02.12.2021.
//

import Foundation
import UIKit

class CustomDataSource: UITableViewDiffableDataSource<String, ToDo> {
    
    var todos = [ToDo]()
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
