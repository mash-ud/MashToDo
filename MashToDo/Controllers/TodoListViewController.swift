//
//  ViewController.swift
//  MashToDo
//
//  Created by Mashud on 3/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let item1 = Item()
        item1.title = "HEY"
        
        itemArray.append(item1)
        
    if let items =  defaults.array(forKey: "TodoItem") as? [Item]
    {
       itemArray = items

     }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == false
//        {
//            cell.accessoryType = .none
//        }
//        else
//        {
//             cell.accessoryType = .checkmark
//        }
       
        return cell
    }
    
    //MARK: TableView Delegate Methode
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//        if itemArray[indexPath.row].done == false
//        {
//            itemArray[indexPath.row].done = true
//        }
//        else
//        {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        
        ///done in CellforRowAtIndexPath Method
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType  = .checkmark
//        }
//
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
       //MARK: Add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textF = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let item = Item()
            item.title = textF.text!
            self.itemArray.append(item)
            self.defaults.set(self.itemArray,forKey: "TodoItem")
            
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
    
    
}

