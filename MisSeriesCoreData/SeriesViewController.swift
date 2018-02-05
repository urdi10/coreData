//
//  ViewController.swift
//  MisSeriesCoreData
//
//  Created by Alejandro on 3/2/18.
//  Copyright © 2018 Alejandro. All rights reserved.
//

import UIKit
import CoreData

class SeriesViewController: UIViewController {

    var series : [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Mi Lista De Series"
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
        
        let fetchRequest = NSFetchRequest(entityName: "Serie")
        
        do {
            series = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addSerie(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Nueva Serie", message: "Nombre de la nueva serie", preferredStyle: .Alert)
        
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
        
        let entity = NSEntityDescription.entityForName("Serie", inManagedObjectContext: managedContext)!
        
        let serie = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
        
        serie.setValue(nombre, forKeyPath: "nombre")
        
        do {
            try managedContext.save()
            series.append(serie)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "mostrarCapitulos" {return}
        
        let celdaRef = sender as! SeriesTableViewCell
        let destinoVC = segue.destinationViewController as! CapitulosViewController
        
        let filaSeleccionada = tableView.indexPathForCell(celdaRef)
        destinoVC.serie = series[(filaSeleccionada?.row)!]
    }

}

// MARK: - UITableViewDataSource
extension SeriesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            let serie = series[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("SeriesTableViewCell", forIndexPath: indexPath) as! SeriesTableViewCell
            cell.nombreSerie?.text = serie.valueForKeyPath("nombre") as? String
            
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let managedContext = appDelegate!.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Capitulo")
            let numeroCapPredicado = NSPredicate(format: "serie = %@", (serie.valueForKeyPath("nombre") as? String)!)
            fetchRequest.predicate = numeroCapPredicado
            var capitulosAux : [NSManagedObject] = []
            do {
                capitulosAux = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            let numeroCapitulos = capitulosAux.count
            cell.numeroCapitulos?.text = "Capítulos: " + String(numeroCapitulos)
            return cell
    }
}

