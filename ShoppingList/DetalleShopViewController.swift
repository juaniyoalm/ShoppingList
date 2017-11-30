//
//  DetalleShopViewController.swift
//  ShoppingList
//
//  Created by Juan Antonio Perez Clemente on 22/11/17.
//  Copyright © 2017 Juan Pérez. All rights reserved.
//

import UIKit
import CoreData

class DetalleShopViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Atributos
    
    @IBOutlet weak var imageDetalle: UIImageView!
    @IBOutlet weak var textFieldDetalle: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
 
    
    var shops: [NSManagedObject] = []
    let imagePickerCtrl = UIImagePickerController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
        textFieldDetalle.delegate = self
        
        saveBtn.isEnabled = false
        textFieldDetalle.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Actions
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // Hide the keyboard.
        textFieldDetalle.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveBtn.isEnabled = textFieldDetalle.hasText
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        saveBtn.isEnabled = textFieldDetalle.hasText
    }
    
    
    @IBAction func seleccionImagen(_ sender: UITapGestureRecognizer) {
        textFieldDetalle.resignFirstResponder()
        imagePickerCtrl.delegate = self
        imagePickerCtrl.sourceType = .photoLibrary
        
        self.present(imagePickerCtrl, animated: true, completion: nil)
    }
    
    
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as AnyObject? !== saveBtn) {return}
        self.save(name: textFieldDetalle.text!, image: imageDetalle.image!)
    }
    
    

    // MARK: ImagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageDetalle.image = selectedImage
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageDetalle.image = orginalImage
        } else {
            print("ERROR EN LA IMAGEN")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: Core Data Functions
    
    func save(name: String, image: UIImage) {
        

        let entity =
            NSEntityDescription.entity(forEntityName: "Shop",
                                       in: managedContext)!
        
        let shop = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        shop.setValue(name, forKeyPath: "name")
        let imageData = UIImagePNGRepresentation(image)
        shop.setValue(imageData, forKeyPath: "logo")
       
        // 4
        do {
            try managedContext.save()
            shops.append(shop)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

