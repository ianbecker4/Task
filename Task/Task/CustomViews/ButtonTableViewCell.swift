//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Ian Becker on 7/29/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: ButtonTableViewCellDelegate?
    
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: Any) {
        guard let delegate = delegate else {return}
        delegate.buttonCellButtonTapped(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Methods
    func updateButton(task: Task) {
        if task.isComplete {
            completeButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            completeButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
    
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        updateButton(task: task)
    }
}
