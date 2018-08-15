//
//  FavoritesViewController.swift
//  RadioOnline
//
//  Created by student on 8/14/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import Foundation

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favoritesTableView: UITableView!
    var stations = [RadioStation]()
    var cell : CustomCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStationsFromJSON()
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        self.favoritesTableView.register(nib, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stations.count)
    }
    var flag = false
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var i = 0
        while i < stations.count {
            if self.stations[i].favorites == "false" {
                self.stations.remove(at: i)
            } else {
                i = i + 1
            }
        }
        if flag == false {
            flag = true
            tableView.reloadData()
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let filePathURL = Bundle.main.url(forResource: "stations", withExtension: "json")
                    
                
                
                let file = try Data(contentsOf: filePathURL!, options: .uncached)

                let data = try encoder.encode(stations)
                
                if let file = FileHandle(forWritingAtPath:"stations.json") {
                    file.write(data)
                }
                
                print(String(data: data, encoding: .utf8)!)
            } catch  {
                print("error encoding")
            }
            
            
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        
        
        cell?.nameLabel.text = stations[indexPath.row].name
        cell?.descriptionLabel.text = stations[indexPath.row].desc
        //cell.imageRadioStation.image = #imageLiteral(resourceName: "delete")
        setImage(station: stations[indexPath.row])
        
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath)-> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            if self.deleteRadiostation(indexPath) {
                completionHandler(true)
                self.favoritesTableView.reloadData()
            } else {
                completionHandler(false)
            }
            
        }
        action.image = UIImage(named: "delete")
        return action
        
    }
    
    func deleteRadiostation(_ indexPath: IndexPath) -> Bool{
        if indexPath.row <= stations.count {
            stations.remove(at: indexPath.row)
            return true
        } else {
            print("error deleting radiostation")
            return false
        }
        
    }
    
    //**************************************************************
    func loadStationsFromJSON() {
        //var stations = [RadioStation]()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Get the Radio Stations
        DataManager.getStationDataWithSuccess() { (data) in
            defer {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            }
            if kDebugLog { print("Stations JSON Found") }
            guard let data = data,
                let jsonDictionary = try? JSONDecoder().decode([String: [RadioStation]].self, from: data),
                let stationsArray = jsonDictionary["station"]
                
                else {
                    if kDebugLog { print("JSON Station Loading Error") }
                    return
            }
            self.stations = stationsArray
        }
        
    }
    
    func setImage(station: RadioStation) {
        
        // Configure the cell...
        //cell.stationName.text = station.name
        
        let imageURL = station.imageURL as NSString
        
        if imageURL.contains("http") {
            
            if let url = URL(string: station.imageURL) {
                cell?.imageRadioStation.loadImageWithURL(url: url) { (image) in
                    // station image loaded
                }
            }
            
        } else if imageURL != "" {
            cell?.imageRadioStation.image = UIImage(named: imageURL as String)
            
        } else {
            cell?.imageRadioStation.image = UIImage(named: "stationImage")
        }
    }
    
    
    
}
