//
//  TodoTableViewSectionsHeader.swift
//  theApp1
//
//  Created by Brusik on 11.12.2021.
//

import Foundation
import UIKit

class TableViewSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "tableViewSectionHeader"
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .left
        
        return label
    }()
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        layer.cornerRadius = 15
        titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
      /*  NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 2)
        ])
       
       */
    }
}
