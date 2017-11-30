//
//  ItemTableViewController.swift
//  ShoppingList
//
//  Created by Juan Antonio Perez Clemente on 27/11/17.
//  Copyright © 2017 Juan Pérez. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
    
    // MARK: Atributos
    weak var shop: Shop!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var items: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
        
        title = shop.name!
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "esta_en.name == %@", shop.name!)
        
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No ha sido posible recuperar la info. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: Actions
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Item",
                                      message: "Add a new item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            if self.comprobarItem(nameItem: nameToSave) {
                self.save(name: nameToSave)
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Aviso", message: "El item ya existe",preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in}
                alert.addAction(cancelAction)
                self.present(alert, animated: true) {
                }
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell",
                                                 for: indexPath) as! ItemTableViewCell
        
        cell.labelItemCell.text = item.value(forKeyPath: "name") as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        managedContext.delete(items[indexPath.row] as NSManagedObject)
        
        do {
            try managedContext.save()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } catch let error as NSError {
            print("Error al eliminar: \(error)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            self.managedContext.delete(self.items[index.row] as NSManagedObject)
            
            do {
                try self.managedContext.save()
                self.items.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .fade)
                tableView.reloadData()
                
            } catch let error as NSError {
                print("Error al eliminar: \(error)")
            }
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            let alert = UIAlertController(title: "Mod Item", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
                guard let textField = alert.textFields?.first,
                    let nameToSave = textField.text else {return}
                
                if self.comprobarItem(nameItem: nameToSave) {
                    let modItem = self.items[index.row] as NSManagedObject
                    modItem.setValue(nameToSave, forKey: "name")
                    do {
                        try self.managedContext.save()
                        tableView.reloadData()
                        
                    } catch let error as NSError {
                        print("Error al eliminar: \(error)")
                    }
                    self.tableView.reloadData()
    
                } else {
                    let alert = UIAlertController(title: "Aviso", message: "El item ya existe",preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in}
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true) {
                    }
                }
  
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addTextField()
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
            
        }
        edit.backgroundColor = .blue
        
        return [edit, delete]
    }
    
    
    // MARK: Core Data Functions
    
    func save(name: String) {
  
        let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)
        
        let item = Item(entity: itemEntity!, insertInto: managedContext)
        
        item.name = name
        
        item.esta_en = shop
        
        do {
            try managedContext.save()
            items.append(item)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func comprobarItem(nameItem: String) -> Bool {
        
        var result: [Item]
        
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND esta_en.name == %@", nameItem, shop.name!)
        
        do {
            result = try managedContext.fetch(fetchRequest)
            if result.count == 0 {return true}
        } catch let error as NSError {
            print("No ha sido posible recuperar la info. \(error), \(error.userInfo)")
        }
        
        return false
    }

}
