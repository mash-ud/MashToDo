//
//  ViewController.swift
//  MashToDo
//
//  Created by Mashud on 3/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController   {
    
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let color = selectedCategory?.colour
        {
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation Cotroller doesn't exist.")
            }
            title = selectedCategory!.name
            if let navBarColor = UIColor(hexString: color)
            {
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
               
                searchBar.barTintColor = navBarColor
                
            }
     
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6")
            else {fatalError()}
        
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(FlatWhite(), returnFlat: true)]
        
    }
    
    //MARK: Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! SwipeTableViewCell
        
       // cell.delegate = self
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            if let colour = selectedCategory?.colour
            {
            if let colour = UIColor(hexString: colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count))
            {
                 cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            }
            
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

    override func updateModel(at indexPath: IndexPath) {
        if let item = self.itemArray?[indexPath.row]
        {
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
                
            }
            catch
            {
                print("Error")
            }
        }
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



