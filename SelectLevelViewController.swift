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
    
    var constants: Constants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
//        layout.estimatedItemSize = CGSize(width: 96, height: 96)
        layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.size.width, height: 60)
        layout.sectionHeadersPinToVisibleBounds = true
        self.collectionView!.collectionViewLayout = layout
        
        self.collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return constants.levelThemes.values.filter( { type(of: $0) == Default.self } ).count
        case 1:
            return constants.levelThemes.values.filter( { type(of: $0) == Default2.self } ).count
        case 2:
            return constants.levelThemes.values.filter( { type(of: $0) == Beach.self } ).count
        default:
            return 0
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var uniqueThemes: [Theme] = []

        // Get number of unique levelThemes (values in Constants levelThemes dict)
        for theme in constants.levelThemes.values {
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
        cell.checkmarkView.isHidden = constants.completeLevels.contains(getLevelNumberFromCell(at: indexPath)) ? false : true

        return cell
    }
    
    func getLevelNumberFromCell(at indexPath: IndexPath) -> Int {
        return indexPath.row + 1 + getNumberOfCellsBeforeThisOne(at: indexPath)
    }
    
    func getNumberOfCellsBeforeThisOne(at indexPath: IndexPath) -> Int {
        var numberOfCellsBeforeThisOne: Int = 0
        
        for _ in 0..<indexPath.section {
            numberOfCellsBeforeThisOne += collectionView.numberOfItems(inSection: indexPath.section - 1)
        }
        
        return numberOfCellsBeforeThisOne
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (self.presentingViewController as! GameViewController).loadLevel(number: getLevelNumberFromCell(at: indexPath))
        self.dismiss(animated: true, completion: {})
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                "header", for: indexPath) as! Header
        
        switch indexPath.section {
        case 0:
            header.title.text = "Default Levels"
        case 1:
            header.title.text = "Default2 Levels"
        case 2:
            header.title.text = "Beach Levels"
        default:
            break
        }
        
            return header
    }
    
}

class Header: UICollectionViewCell  {
    let title: UILabel = UILabel()

    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }

    func setupHeaderViews()   {
        addSubview(title)

        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        title.widthAnchor.constraint(equalToConstant: 120).isActive = true
        title.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
