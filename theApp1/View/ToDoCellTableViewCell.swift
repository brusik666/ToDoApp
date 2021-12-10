//
//  ToDoCellTableViewCell.swift
//  theApp1
//
//  Created by Brusik on 09.08.2021.protocol
import UIKit

protocol ToDoCellDelegate: AnyObject {
    func checkMarkTapped(sender: ToDoCellTableViewCell)
    func shareButtonTapped(sender: ToDoCellTableViewCell)
}

class ToDoCellTableViewCell: UITableViewCell {
    
    weak var delegate: ToDoCellDelegate?

    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var shareButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkMarkTapped(sender: self)
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareButtonTapped(sender: self)
    }
    
}
