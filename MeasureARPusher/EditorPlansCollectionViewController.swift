//
//  EditorPlansCollectionViewController.swift
//  MeasureARPusher
//
//  Created by Alyssia Goodwin on 4/2/19.
//  Copyright © 2019 Celina. All rights reserved.
//


import UIKit
extension UIColor {
    static func random() -> UIColor{
        return UIColor(
            red: CGFloat(drand48()),
            green: CGFloat(drand48()),
            blue: CGFloat(drand48()),
            alpha: 1.0
        )
    }
}

struct Item {
    var color: UIColor
}

class CustomFlowLayout : UICollectionViewFlowLayout {
    var insertingIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        //if insertingIndexPaths.contains(itemIndexPath) {
        attributes?.alpha = 0.0
        attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        //attributes?.transform = CGAffineTransform(translationX: 0, y: 500.0)
        
        print(attributes)
        //}
        
        return attributes
    }
}

class EditorPlansCollectionViewController: UICollectionViewController {
    var items = [Item]()
    
   
    @IBAction func addRight(_ sender: Any) {
        addItem()
        collectionView?.performBatchUpdates({
            self.collectionView?
                .insertItems(at: [IndexPath(item: self.items.count - 1, section: 0)])
        }, completion: nil)
        
    }
    @IBAction func addLeft(_ sender: Any) {
        addItem()
        
        collectionView?.performBatchUpdates({
            self.collectionView?
                .insertItems(at: [IndexPath(item: 0, section: 0)])
        }, completion: nil)
    }
    @IBAction func add(_ sender: UIBarButtonItem) {
        addItem()
        
        collectionView?.performBatchUpdates({
            self.collectionView?
                .insertItems(at: [IndexPath(item: 0, section: 0)])
        }, completion: nil)
    }
    
    func addItem() {
        items.append(Item(color: .random()))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.setCollectionViewLayout(CustomFlowLayout(), animated: false)
        
        for _ in 0...10 { addItem() }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
        
        cell.contentView.backgroundColor = items[indexPath.item].color
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items.remove(at: indexPath.item)
        
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth: CGFloat = flowLayout.itemSize.width
        let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        var collectionWidth = collectionView.frame.size.width
        if #available(iOS 11.0, *) {
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        }
        let totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
        if totalWidth <= collectionWidth {
            let edgeInset = (collectionWidth - totalWidth) / 2
            return UIEdgeInsets(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
        } else {
            return flowLayout.sectionInset
        }
    }
}
