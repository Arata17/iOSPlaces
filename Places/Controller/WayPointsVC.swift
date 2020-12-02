//
//  WayPointsVC.swift
//  Places
//
//  Created by Мирас on 11/1/20.
//

import UIKit
import CoreData

protocol PinZoomProtocol {
    func setCenter(latitude lat: Double, longitude lon: Double, name: String)
}
class WayPointsVC: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var annotationsList = [Annotation]()
    var delegate: PinZoomProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "reusableCustomCell")

        loadPins()
        tableView.reloadData()
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return annotationsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCustomCell", for: indexPath) as! CustomCell

        cell.title.text = annotationsList[indexPath.row].title
        cell.subTitle.text = annotationsList[indexPath.row].subtitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, boolValue) in
            self.context.delete(self.annotationsList[indexPath.row])
            self.annotationsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.savePins()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pin = annotationsList[indexPath.row]
        delegate?.setCenter(latitude: pin.lat, longitude: pin.lon, name: pin.title!)
        navigationController?.popViewController(animated: true)
    }

    func savePins(){
        do{
            try self.context.save()
        } catch{
            print(error)
        }
    }
    
    
    func loadPins(){
        let request: NSFetchRequest<Annotation> = Annotation.fetchRequest()
        do{
            annotationsList = try context.fetch(request)
        }catch{
            print(error)
        }

    }

    
   
}
    
