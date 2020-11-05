//
//  LocationsTableViewController.swift
//  MyMap
//
//  Created by Madina Tazhiyeva on 11/1/20.
//  Copyright © 2020 Madina Tazhiyeva. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class LocationsTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Data.locations.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            context.delete(Data.locations[indexPath.row] )
            do {
                try context.save()
                Data.locations.remove(at: indexPath.row)
            } catch _ {
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let location = Data.locations[indexPath.row]
        cell.textLabel?.text = location.locationName
        cell.detailTextLabel?.text = location.locationDescription
        return cell
    }
    
    func loadLocations()-> [Locations]{
        return Data.locations
    }
    
}
