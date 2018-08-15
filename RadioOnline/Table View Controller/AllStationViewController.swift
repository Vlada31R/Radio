//
//  AllStationViewController.swift
//  RadioOnline
//
//  Created by student on 8/15/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class AllStationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var stations = [RadioStation]()
    var cell : CustomCell?

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //stations = DataManager.loadStationsFromJSON()
        loadStationsFromJSON()
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stations.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        cell?.nameLabel.text = stations[indexPath.row].name
        cell?.descriptionLabel.text = stations[indexPath.row].desc
        //cell.imageRadioStation.image = #imageLiteral(resourceName: "delete")
        setImage(station: stations[indexPath.row])
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let flagAction = self.contextualToggleFlagAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [flagAction])
        return swipeConfig
    }
    
    func contextualToggleFlagAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Flag") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            if self.addFavorites(indexPath) {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            
        }
        action.image = UIImage(named: "favorites")
        return action
    }
    
    func addFavorites(_ indexPath: IndexPath) -> Bool{
        let c = tableView.cellForRow(at: indexPath)
        c?.backgroundColor = UIColor.yellow
        return true
    }
    
    
    @IBAction func action(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AllVC") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = viewController
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
