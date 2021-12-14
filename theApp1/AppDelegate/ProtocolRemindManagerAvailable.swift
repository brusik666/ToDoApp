//
//  ProtocolRemindManagerAvailable.swift
//  theApp1
//
//  Created by Brusik on 13.12.2021.
//

import Foundation
import UIKit

protocol RemindManagerAvailable {
    var remindManager: ReminderManager? { get }
}

extension RemindManagerAvailable {
    var remindManager: ReminderManager? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.remindManager
    }
}
