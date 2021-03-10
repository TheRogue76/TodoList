//
//  ViewController.swift
//  TodoList
//  Created by Parsa Nasirimehr on 12/13/1399 AP.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray: [String] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: constants.TodoListArray) as? [String] {
            itemArray = items
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: constants.addTitle, message: "", preferredStyle: .alert)
        let add = UIAlertAction(title: constants.addAction, style: .default) { (addAction) in
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: constants.TodoListArray)
            
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
}

//MARK: - TableViewDataSource
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.TodoItemCell, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
}

//MARK: - TableViewDelegate
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
