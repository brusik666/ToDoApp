//
//  LaunchScreenViewController.swift
//  theApp1
//
//  Created by Brusik on 12.12.2021.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var doLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGray.cgColor
        doLabel.textColor = UIColor.red
        
        UIView.animate(withDuration: 1, animations: {

            let rotateTransform = CGAffineTransform(rotationAngle: (.pi) * 1)

            self.launchImageView.transform = rotateTransform
        }) { (_) in
            UIView.animate(withDuration: 1.2) {

                self.launchImageView.transform = CGAffineTransform.identity
            }
        }

        UIView.animate(withDuration: 2, animations: {
            self.view.backgroundColor = UIColor.myOrange
            self.launchImageView.alpha = 0.85
            let transform = CGAffineTransform(scaleX: 3, y: 2.4)
            self.doLabel.transform = transform
            self.doLabel.textColor = UIColor.white
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: DispatchWorkItem(block: {
                self.performSegue(withIdentifier: "todoTableViewController", sender: nil)
            }))

        }
    }
}
