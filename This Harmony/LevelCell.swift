//
//  LevelCell.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/3/21.
//

import UIKit
import Foundation

class LevelCell: UICollectionViewCell {
    
    @IBOutlet weak var levelNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .lightGray
    }
}
