//
//  CollectionViewCell.swift
//  RadioStation
//
//  Created by student on 8/14/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cell: CollectionViewCellXib!
    
    func configureStationCell(station: RadioStation) {
        
        // Configure the cell...
        cell.stationName.text = station.name
        
        let imageURL = station.imageURL as NSString
        
        if imageURL.contains("http") {
            
            if let url = URL(string: station.imageURL) {
                cell.stationImage.loadImageWithURL(url: url) { (image) in
                    // station image loaded
                }
            }
            
        } else if imageURL != "" {
            cell.stationImage.image = UIImage(named: imageURL as String)
            
        } else {
            cell.stationImage.image = UIImage(named: "stationImage")
        }
    }
}
extension UIImageView {
    
    func loadImageWithURL(url: URL, callback: @escaping (UIImage) -> ()) {
        let session = URLSession.shared
        
        let downloadTask = session.downloadTask(with: url, completionHandler: {
            [weak self] url, response, error in
            
            if error == nil && url != nil {
                if let data = NSData(contentsOf: url!) {
                    if let image = UIImage(data: data as Data) {
                        
                        DispatchQueue.main.async(execute: {
                            
                            if let strongSelf = self {
                                strongSelf.image = image
                                callback(image)
                            }
                        })
                    }
                }
            }
        })
        
        downloadTask.resume()
    }
}
