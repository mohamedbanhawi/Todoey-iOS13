//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mohamed Elbanhawi on 26/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() // realm instance failure can only occur the first time we try it i.e. in the AppDelegate
    
    var categoryArray: Results<CategoryItem>? // auto-updating array no need to append
        
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() // load categories from Realm and start auto-updating 
    }
    
    // MARK:- TableView Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = categoryArray?[indexPath.row].name ?? "No Categories Added Yet :("
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
                let newCategory = CategoryItem()
                
                newCategory.name = textField.text!
                
                self.saveCategories(category: newCategory)
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Core Data CRUD
    func saveCategories(category: CategoryItem) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Failed to add category:\(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadCategories(){
        
        categoryArray = realm.objects(CategoryItem.self)
        
        tableView.reloadData()
        
    }
    
    
    // MARK:- TableView Data Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        
        if let indexPath = selectedIndexPath {
            destinationVC.selectedCategory = categoryArray?[indexPath.row] 
        }
        
    }
    
    
}
