//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tatiana Bondarenko on 9/9/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category) {
        do {
//            try context.save()
            try realm.write({
                try realm.add(category)
            })
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//
//        tableView.reloadData()
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = categories?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(categoryToDelete)
                })
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo list", message: "", preferredStyle: .alert)
        
//        let action = UIAlertAction(title: "Add Item", style: .default) { action in
//
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//            self.categories.append(newCategory)
//
//            self.saveCategories()
//
//        }
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
        
                    let newCategory = Category()
                    newCategory.name = textField.text!
//                    self.categories.append(newCategory)
        
                    self.saveCategories(category: newCategory)
        
            }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new list..."
            textField =  alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
