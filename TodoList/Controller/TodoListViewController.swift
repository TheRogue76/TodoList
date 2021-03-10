//
//  ViewController.swift
//  TodoList
//  Created by Parsa Nasirimehr on 12/13/1399 AP.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(constants.ItemPlist)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: constants.addTitle, message: "", preferredStyle: .alert)
        let add = UIAlertAction(title: constants.addAction, style: .default) { (addAction) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: constants.cancelAction, style: .cancel) { (cancelAction) in
            print("cancelled")
        }
        alert.addTextField { (addText) in
            addText.placeholder = "Create New Item"
            textField = addText
        }
        alert.addAction(cancel)
        alert.addAction(add)
        present(alert, animated: true)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding")
        }
    }
    
    func loadItems() {
        do {
            if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            }
        } catch {
            print("error reading")
        }
    }
}

//MARK: - TableViewDataSource
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.TodoItemCell, for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none
        return cell
    }
}

//MARK: - TableViewDelegate
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
