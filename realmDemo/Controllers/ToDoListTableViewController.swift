//
//  ToDoListTableTableViewController.swift
//  realmDemo
//
//  Created by 維衣 on 2021/5/10.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: SwipeTableViewController {
    
    var todoItems: Results<ItemRealm>?
    var selectedCategory: CategoryRealm? {
        didSet{
            loadToDoItems()
        }
    }
    
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let todoItemForDeletion = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(todoItemForDeletion)
                }
            } catch {
                print("**error deleting todo item: \(error)")
            }
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let todoItemForEdition = todoItems?[indexPath.row] {
            var textField = UITextField()

            let alert = UIAlertController(title: "Edit item title", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Edit Item", style: .default) { (action) in
                
                do {
                    try self.realm.write {
                        todoItemForEdition.title = textField.text!
                    }
                } catch {
                    print("**Edit item fail:\(error)")
                }

                self.tableView.reloadData()
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.text = todoItemForEdition.title
                
                textField = alertTextField
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("**error saving done status\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
        @IBAction func addNewItem(_ sender: UIBarButtonItem) {
            var textField = UITextField()
//            let alert = UIAlertController(title: "Add new to item", message: "", preferredStyle: .actionSheet)
            let alert = UIAlertController(title: "Add new to item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
//            let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in

                if let currrentCategory = self.selectedCategory {
                    do {
//                        print("**do")
                        try self.realm.write {
                            let newTodo = ItemRealm()
                            newTodo.title = textField.text!
                            newTodo.dateCreated = Date()
                            currrentCategory.itemRealms.append(newTodo)
                        }
                    } catch {
                        print("**Add new items fail:\(error)")
                    }
                }
                self.tableView.reloadData()
            }
                alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "enter sth."
                textField = alertTextField
//                print("**textField == \(textField)")
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    
    func loadToDoItems(){
        todoItems = selectedCategory?.itemRealms.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension ToDoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadToDoItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
