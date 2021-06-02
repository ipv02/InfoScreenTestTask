//
//  ViewController.swift
//  InfoScreenTestTask
//
//  Created by Igor Pogiba-Vishnevskiy on 02.06.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - IB Outlet
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private properties
    private var childs: [Child] = []
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
    }
    
    //MARK: - IB Action
    @IBAction func pressPlusButton(_ sender: UIButton) {
        showAlert(with: "Добавить ребенка", and: "заполните поля имя и возраст")
    }
    
    //MARK: - Alert controller
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Введите имя ребенка"
            field.returnKeyType = .continue
        }
        
        alert.addTextField { field in
            field.placeholder = "Введите возраст"
            field.returnKeyType = .continue
            field.keyboardType = .numberPad
        }
        
        guard let fields = alert.textFields, fields.count == 2 else { return }
        
        let nameTextfield = fields[0]
        let ageTextfield = fields[1]
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            
            guard let name = nameTextfield.text, !name.isEmpty,
                  let age = ageTextfield.text, !age.isEmpty else { return }
            
            self.saveChild(name: name, age: age)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func saveChild(name: String, age: String) {
        
        childs.append(Child(name: name, age: age))
        
        let indexPath = IndexPath(row: childs.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - TableView data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        childs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let child = childs[indexPath.row]
        
        cell.textLabel?.text = "Имя ребенка:" + " " + child.name
        cell.detailTextLabel?.text = "Возраст:" + " " + child.age
        
        if childs.count == 5 {
            plusButton.isHidden = true
        }
        return cell
    }
}

//MARK: - TableView delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        childs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if childs.count <= 4 {
            plusButton.isHidden = false
        }
    }
}

//MARK: - Textfield delegate
extension ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
