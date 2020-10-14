//
//  ViewController.swift
//  coreDataTutorial
//
//  Created by Marina Beatriz Santana de Aguiar on 13.10.20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var users = [User]()
    let entity = "User"
    var managedObjectContext: NSManagedObjectContext!
    var persistentContainer: NSPersistentContainer!
    
    let userTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupContainer()
        
        //Use this to find sqlite file
        let container = NSPersistentContainer(name: "coreDataTutorial")
        print(container.persistentStoreDescriptions.first?.url)
  
    }
    
    
    private func setupContainer() {
        persistentContainer = NSPersistentContainer(name: "coreDataTutorial")
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Could not load Core Data Stack. Error: \(error)")
            }
        }
        managedObjectContext = persistentContainer.viewContext
    }
    
    @objc private func saveUser() {
        guard let name = getUsersName() else { return }
        let user = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedObjectContext) as! User
        user.name = name
        
        do {
            try managedObjectContext.save()
            
        } catch {
            fatalError("Failure to save user in context: \(error)")
        }
    }
    
    
    @objc private func fetchUsers() -> [User] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let fetchedUsers = try managedObjectContext.fetch(fetch) as! [User]
            users = fetchedUsers
            return users
        } catch {
            fatalError("Could not fetch from model")
        }
    }
    @objc
    private func printUsers() {
        let fetchedUsers = fetchUsers()
        if fetchedUsers.isEmpty { print("No users saved."); return }

        for user in users {
            print("Name: \(user.name)")
        }
    }
    

    
    @objc private func removeAllUsers() {
        if users.isEmpty { fetchUsers() }
        
        for user in users {
            managedObjectContext.delete(user)
        }
        
        do  {
            try managedObjectContext.save()
        } catch {
            fatalError("Could not save context after deletion")
        }
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "Add new user"
        label.tintColor = .label
        label.textAlignment = .center
        
        view.addSubview(userTextField)
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.placeholder = "Max Mustermann"
        userTextField.font = UIFont.preferredFont(forTextStyle: .body)
        userTextField.tintColor = .label
        userTextField.borderStyle = .roundedRect
        
        let addUserButton = UIButton()
        addUserButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addUserButton)
        addUserButton.addTarget(self, action: #selector(saveUser), for: .touchUpInside)
        addUserButton.setTitle("Add", for: .normal)
        addUserButton.setTitleColor(.systemBackground, for: .highlighted)
        addUserButton.backgroundColor = .systemGreen
    
        
        let removeUserButton  = UIButton()
        removeUserButton.translatesAutoresizingMaskIntoConstraints = false
        removeUserButton.addTarget(self, action: #selector(removeAllUsers), for: .touchUpInside)
        view.addSubview(removeUserButton)
        removeUserButton.setTitleColor(.systemBackground, for: .highlighted)
        removeUserButton.setTitle("Clear All", for: .normal)
        removeUserButton.backgroundColor = .systemRed
        
        
        let showAllUsersButton  = UIButton()
        showAllUsersButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showAllUsersButton)
        showAllUsersButton.addTarget(self, action: #selector(printUsers), for: .touchUpInside)
        showAllUsersButton.setTitleColor(.systemBackground, for: .highlighted)
        showAllUsersButton.setTitle("Show All", for: .normal)
        showAllUsersButton.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            userTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25),
            userTextField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            userTextField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            
            addUserButton.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 25),
            addUserButton.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            addUserButton.trailingAnchor.constraint(equalTo: label.trailingAnchor),

            showAllUsersButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            showAllUsersButton.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            showAllUsersButton.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            showAllUsersButton.heightAnchor.constraint(equalToConstant: 40),
            
            removeUserButton.bottomAnchor.constraint(equalTo: showAllUsersButton.topAnchor, constant: -5),
            removeUserButton.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            removeUserButton.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            removeUserButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    private func getUsersName() -> String? {
        guard userTextField.text != nil else {
            return nil
        }
        return userTextField.text!
    }
}

