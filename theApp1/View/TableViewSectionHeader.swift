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
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
     //   layer.borderWidth = 1
    //  layer.borderColor = UIColor.darkGray.cgColor
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowColor = UIColor.systemPurple.cgColor
        titleLabel.layer.shadowRadius = 15
        titleLabel.layer.shadowOpacity = 0.5
  //      titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
       //     titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
            self.widthAnchor.constraint(equalToConstant: titleLabel.bounds.width)
        ])
       
       
    }
}
