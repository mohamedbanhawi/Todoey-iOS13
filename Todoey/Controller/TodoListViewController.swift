//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // MARK: - Properties
    var itemArray = [Item]()
    
    var selectedCategory: CategoryItem? {
        
        didSet{
            loadItems()
        }
        
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)
    
    // use singelton of the current application delegate with as type AppDelegate
    // use context to modify container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    // MARK: - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row].title
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item
        cell.accessoryType =  itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done.toggle()
        
        // order is important when deleting
        //        context.delete(itemArray[indexPath.row]) // delete item from db first
        //        itemArray.remove(at: indexPath.row) // remove from list
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                
                // create new item in context
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done  = false
                newItem.parentCategory = self.selectedCategory // point to category
                self.itemArray.append(newItem)
                
                self.saveItems()
                
                self.tableView.reloadData()
            } else {
                action.isEnabled = false
            }
        }
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    // default value for a request
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
           request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // a filter for the query
        // case insensitve
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        
        // how to sort data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    } // end of searchBarSearchButtonClicked
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // go to the background
            }
        }
    }
    
}

