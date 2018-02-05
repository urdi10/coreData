//
//  CapitulosViewController.swift
//  MisSeriesCoreData
//
//  Created by Alejandro on 4/2/18.
//  Copyright © 2018 Alejandro. All rights reserved.
//

import UIKit
import CoreData

class CapitulosViewController: UIViewController {

    var capitulos : [NSManagedObject] = []
    var serie : NSManagedObject?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Lista de Capítulos"
        tableView.backgroundColor = UIColor.grayColor()
        tableView.separatorColor = UIColor.blackColor()
        
        navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Capitulo")
        
        do {
            /*let todosCapitulos*/ capitulos = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            /*for cap in todosCapitulos {
                if (cap.valueForKey("serie") as? NSManagedObject) == serie {
                    capitulos.append(cap)
                }
            }*/
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addCapitulo(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Nuevo Capítulo", message: "Nombre del nuevo capítulo", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Guardar", style: .Default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            
            self.save(nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Default, handler: .None)
        
        alert.addTextFieldWithConfigurationHandler(.None)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: .None)
    }
    
    func save(nombre: String) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Capitulo", inManagedObjectContext: managedContext)!
        
        let capitulo = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
        
        capitulo.setValue(nombre, forKeyPath: "nombre")
        capitulo.setValue("0", forKeyPath: "nota")
        capitulo.setValue(serie, forKey: "serie")
        
        do {
            try managedContext.save()
            capitulos.append(capitulo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension CapitulosViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capitulos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            let capitulo = capitulos[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("CapitulosTableViewCell", forIndexPath: indexPath) as! CapitulosTableViewCell
            cell.nombreCapitulo?.text = capitulo.valueForKeyPath("nombre") as? String
            cell.valoracion?.text = "Valoración: " + (capitulo.valueForKeyPath("nota") as? String)! + "/10"
            return cell
    }
}
