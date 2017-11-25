//
//  ShopsTableViewController.swift
//  ShoppingList
//
//  Created by Juan Antonio Perez Clemente on 21/11/17.
//  Copyright © 2017 Juan Pérez. All rights reserved.
//

import UIKit
import CoreData

class ShopsTableViewController: UITableViewController {
    
    // MARK: Atributos
    
    var shops: [NSManagedObject] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        
        title = "Shops"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        //let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Shop")
        
        let fetchRequest : NSFetchRequest<Shop> = Shop.fetchRequest()
        
        //3
        do {
            shops = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No ha sido posible recuperar la info. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func fromDetalleView (segue: UIStoryboardSegue!) {
        viewWillAppear(true)
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shop = shops[indexPath.row]
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "ShopsTableViewCell",
                                          for: indexPath) as! ShopsTableViewCell

        cell.labelShops.text =
            shop.value(forKeyPath: "name") as? String
        
        if let aux = shop.value(forKeyPath:"logo") as? Data {
            cell.imageShops.image = UIImage(data:aux)
            
        } else {
            cell.imageShops.image = UIImage(named: "default")
        }
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // BORRADO DE SHOPS
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != .delete {return}
        

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(shops[indexPath.row] as NSManagedObject)

        
        do {
            try managedContext.save()
            shops.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } catch let error as NSError {
            print("Error al eliminar: \(error)")
        }
    }
    
}
