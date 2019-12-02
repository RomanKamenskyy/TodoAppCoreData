//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by roman on 17.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryTableViewController: SwipeTableViewController {
    //let categoryArray: [Category] = []
    var categoryArray = [Category]()
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        loadItem()
        
        tableView.rowHeight = 60
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  super.tableView(tableView, cellForRowAt: indexPath)
      
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    
    // MARK: - Table view manipulations
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error while loading data with error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error while loading data with error \(error)")
        }
        
       // tableView.reloadData()
    }
    
    func saveCategory() {
        
        do{
           try context.save()
        } catch {
            print("error while saving with error \(error)")
        }
        
        tableView.reloadData()
    }
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemVC"{
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    
        
    
    override func updateModel(at indexPath: IndexPath) {

        let deleteCategory = categoryArray[indexPath.row]
        
        print("удаляемая категория \(deleteCategory)")
        
        
//        let deleteItem = itemArray.filter { $0.parentCategory }
        
              
              
        
//        let deleteItem = itemArray.filter { number : Int -> Bool in
//            return number
//
//        }
        
        
      //  print(deleteItem)
        context.delete(deleteCategory)
        
        self.categoryArray.remove(at: indexPath.row)
        
        do {
            try context.save()
            print("Data deleted successfully")
        } catch {
            print("error while delete date with \(error)")
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Tabke view add button
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add new", style: .default) { action in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { textFieldAction in
            textFieldAction.placeholder = "add new category" 
            textField = textFieldAction
            
        }
        
        alert.addAction(action) 
        
        present(alert, animated: true, completion: nil)
    }
    
}

