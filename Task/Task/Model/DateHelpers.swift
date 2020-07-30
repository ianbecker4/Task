//
//  DateHelpers.swift
//  Task
//
//  Created by Ian Becker on 7/29/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation

extension Date {
    
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
