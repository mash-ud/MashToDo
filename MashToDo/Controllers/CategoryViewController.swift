//
//  TableViewController.swift
//  MashToDo
//
//  Created by Mashud on 5/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//
import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController  {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        tableView.separatorStyle = .none
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  let item = categoryArray?[indexPath.row]
        {
            cell.textLabel?.text = item.name
        
            guard let color = UIColor(hexString: item.colour) else {
                fatalError()
            }
            cell.backgroundColor =  color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItem(category: Category)
    {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch
        {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItem()
    {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categoryArray?[indexPath.row]
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
    
    //MARK: - Add New Categories


    @IBAction func addBtnclicked(_ sender: UIBarButtonItem) {
        
        var textF = UITextField()

        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let category = Category()
            category.name = textF.text!
            category.colour = UIColor.randomFlat.hexValue()
            self.saveItem(category: category)

        }
        alert.addTextField{
            (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textF = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
