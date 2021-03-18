//
//  SelectLevelViewController.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/3/21.
//

import UIKit
import SpriteKit
import Foundation

class SelectLevelViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numLevels
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: LevelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LevelCell
        let cellNumber: Int = indexPath.row + 1
        cell.levelNumberLabel.text = String(cellNumber)

        // Toggle cell's checkmarkView
        cell.checkmarkView.isHidden = Constants.completeLevels.contains(cellNumber) ? false : true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (self.presentingViewController as! GameViewController).loadLevel(number: indexPath.row + 1)
        self.dismiss(animated: true, completion: {})
    }
    
    
}
