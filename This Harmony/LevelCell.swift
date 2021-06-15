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
    @IBOutlet weak var checkmarkView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.levelNumberLabel.textColor = UIColor.black
    }
    
}
