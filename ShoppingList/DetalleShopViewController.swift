//
//  DetalleShopViewController.swift
//  ShoppingList
//
//  Created by Juan Antonio Perez Clemente on 22/11/17.
//  Copyright © 2017 Juan Pérez. All rights reserved.
//

import UIKit

class DetalleShopViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageDetalle: UIImageView!
    @IBOutlet weak var textFieldDetalle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDetalle.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func seleccionImagen(_ sender: UITapGestureRecognizer) {
        textFieldDetalle.resignFirstResponder()
        let imagePickerCtrl = UIImagePickerController()
        imagePickerCtrl.sourceType = .photoLibrary
        imagePickerCtrl.delegate = self
        present(imagePickerCtrl, animated: true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageDetalle.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

}
