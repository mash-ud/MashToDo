//
//  ViewController.swift
//  MashToDo
//
//  Created by Mashud on 3/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController   {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        
        //print(dataFilePath)
        
        
       // loadItems()
        
//    if let items =  defaults.array(forKey: "TodoItem") as? [Item]
//    {
//       itemArray = items
//
//     }
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
        
        //Update from Core Data
       /// itemArray[indexPath.row].setValue("Change title", forKey: "title")
        //Delete from Core Data
       /// context.delete(itemArray[indexPath.row])
       /// itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//        if itemArray[indexPath.row].done == false
//        {
//            itemArray[indexPath.row].done = true
//        }
//        else
//        {
//            itemArray[indexPath.row].done = false
//        }
        saveItem()
        //tableView.reloadData()
        
        ///done in CellforRowAtIndexPath Method
        

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
       //MARK: Add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textF = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = textF.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveItem()
           
        }
        alert.addTextField{
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textF = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
       
    }
    
    func saveItem()
    {
        //let encoder = PropertyListEncoder()
        do
        {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
            
        }
        catch{
            print("Error Saving Data")
        }
        
        //  self.defaults.set(self.itemArray,forKey: "TodoItem")
    
        self.tableView.reloadData()
    }
    
//    func loadItems()
//    {
//        if let data = try? Data(contentsOf: dataFilePath!)
//        {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch
//            {
//
//            }
//        }
//    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil ){
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
        if let compoundPredicate = predicate
        {
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,compoundPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        do{
        itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error Fetching data")
        }
        tableView.reloadData()
    }
    
   
    
    
}

extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request,predicate: predicate)
//        do{
//            itemArray = try context.fetch(request)
//        }
//        catch
//        {
//            print("Error Fetching data")
//        }
//
  //      tableView.reloadData()
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


