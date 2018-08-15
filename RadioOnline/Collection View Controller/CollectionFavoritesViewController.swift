//
//  CollectionFavoritesViewController.swift
//  RadioOnline
//
//  Created by student on 8/15/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class CollectionFavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var favourites = [RadioStation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(lpgr)
    }
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.ended {
            return
        }
        
        let point = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            
            let alertController = UIAlertController(title: "Station", message:favourites[index[1]].name, preferredStyle: .alert)
            
            let image = UIImage(named: "delete")
            let imageView = UIImageView()
            imageView.image = image
            imageView.frame =  CGRect(x: 35, y: 89, width: 24, height: 24)
            alertController.view.addSubview(imageView)
            let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.default)
            { (action) in
                self.favourites.remove(at: index[1])
                self.collectionView?.reloadData()
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertController.addAction(removeAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Could not find index path")
        }
    }
}
