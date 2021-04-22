//
//  SelectLevelViewController.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/3/21.
//

import UIKit
import SpriteKit
import Foundation

class SelectLevelViewController: UICollectionViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return Constants.levelThemes.values.filter( { type(of: $0) == Default.self } ).count
        case 1:
            return Constants.levelThemes.values.filter( { type(of: $0) == Default2.self } ).count
        case 2:
            return Constants.levelThemes.values.filter( { type(of: $0) == Beach.self } ).count
        default:
            return 0
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var uniqueThemes: [Theme] = []

        // Get number of unique levelThemes (values in Constants levelThemes dict)
        for theme in Constants.levelThemes.values {
            if !uniqueThemes.contains(theme) {
                uniqueThemes.append(theme)
            }
        }

        return uniqueThemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LevelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LevelCell
        let cellNumber: Int = indexPath.row + 1
        cell.levelNumberLabel.text = String(cellNumber)

        // Toggle cell's checkmarkView
        cell.checkmarkView.isHidden = Constants.completeLevels.contains(cellNumber) ? false : true
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (self.presentingViewController as! GameViewController).loadLevel(number: indexPath.row + 1)
        self.dismiss(animated: true, completion: {})
    }
    
    
}
