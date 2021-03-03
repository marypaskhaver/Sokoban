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
        self.view.backgroundColor = .red
        print("hello!")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: LevelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LevelCell
        let cellNumber: Int = indexPath.row + 1
        cell.levelNumberLabel.text = String(cellNumber)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (self.presentingViewController as! GameViewController).loadLevel(number: indexPath.row + 1)
        self.dismiss(animated: true, completion: {})
    }
    
    
}
