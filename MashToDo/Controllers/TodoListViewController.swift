//
//  ViewController.swift
//  MashToDo
//
//  Created by Mashud on 3/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController   {
    
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    //MARK: Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
              cell.textLabel?.text = "No Item Added"
        }
        
        return cell
    }
    
    //MARK: TableView Delegate Methode
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]
        {
            do{
                try realm.write {
                    item.done = !item.done
                    //for delete
                    //realm.delete(item)
                }
               
            }
            catch
            {
                print("Error")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
     //  MARK: Add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textF = UITextField()

        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textF.text!
                        item.done = false
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }

                }
                catch{
                    
                }
            }
            
            self.tableView.reloadData()
            
         
        }
        alert.addTextField{
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textF = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)


    }

    func loadItems( ){
      itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }




}
//
extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
         
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
}


