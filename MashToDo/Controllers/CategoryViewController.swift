//
//  TableViewController.swift
//  MashToDo
//
//  Created by Mashud on 5/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//
import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    //MARK: - Data Manipulation Methods
    
    func saveItem()
    {
        do{
            try context.save()
        }
        catch
        {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do{
            categoryArray = try context.fetch(request)
        }
        catch
        {
            print("Error Fetching data")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories


    @IBAction func addBtnclicked(_ sender: UIBarButtonItem) {
        
        var textF = UITextField()

        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            let category = Category(context: self.context)
            category.name = textF.text!
            self.categoryArray.append(category)
            self.saveItem()

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
            destVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
