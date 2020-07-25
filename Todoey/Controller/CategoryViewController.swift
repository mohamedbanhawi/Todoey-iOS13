//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mohamed Elbanhawi on 26/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    

    var categoryArray = [CategoryItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() // load categories from CoreData
    }
    
    // MARK:- TableView Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = categoryArray[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = name
        
        return cell
    }

    // MARK:- TableView Data Manipulation methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
         
         let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
         
         let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
             if textField.text != "" {
                 
                 // create new item in context
                 let newCategory = CategoryItem(context: self.context)
                 newCategory.name = textField.text!
                
                 self.categoryArray.append(newCategory)
                 
                 self.saveCategories()
                 
             }
         }
         
         alert.addTextField { (alertTextField) in
             
             textField = alertTextField
         }
         
         alert.addAction(action)
         
         present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Core Data CRUD
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Failed to add category:\(error)")
        }
        
        tableView.reloadData()

        
    }
    
    func loadCategories(with request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()){
    
        do {
            categoryArray = try context.fetch(request)

        } catch {
            print("Failed to load category:\(error)")

        }
        
        tableView.reloadData()

    }
    
    
    // MARK:- TableView Data Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.delaysContentTouches = false

        performSegue(withIdentifier: "goToItems", sender: self)
        
        print(categoryArray[selectedIndexPath!.row].name!)

    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! TodoListViewController


        if let indexPath = selectedIndexPath {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }

    }

    
}
