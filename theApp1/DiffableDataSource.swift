//
//  DiffableDataSource.swift
//  theApp1
//
//  Created by Brusik on 02.12.2021.
//

import Foundation
import UIKit

class CustomDataSource: UITableViewDiffableDataSource<String, ToDo> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  /*  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if let item = self.itemIdentifier(for: indexPath) {
            var snapshot = self.snapshot()
            snapshot.deleteItems([item])
            self.apply(snapshot, animatingDifferences: true, completion: nil)
            
        }
    } */
}
