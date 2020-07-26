//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    // MARK: - Properties
    var itemArray: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: CategoryItem? {
        
        didSet{
            loadItems()
        }
        
    }
    
    // use singelton of the current application delegate with as type AppDelegate
    // use context to modify container
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray?[indexPath.row].title ?? "No Items"
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item
        cell.accessoryType =  itemArray?[indexPath.row].done ?? false ? .checkmark : .none
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
            try realm.write{
                item.done.toggle() // must be done inside the write

                }
                
            } catch {
                print("Error updating object")
            }
        }
                
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
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done  = false
                            currentCategory.items.append(newItem) // must be performed within the realm.write
                            self.realm.add(newItem)
                        }
                    } catch {
                        print("Error saving context \(error)")
                    }
                    
                }
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
    
    func saveItems(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    // default value for a request
    func loadItems() {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
}

// MARK: - UISearchBarDelegate

//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        // a filter for the query
//        // case insensitve
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
//
//        // how to sort data
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//
//    } // end of searchBarSearchButtonClicked
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder() // go to the background
//            }
//        }
//    }
//
//}

