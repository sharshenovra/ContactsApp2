import UIKit
import SnapKit
import RealmSwift

class Contact: Object {
    @objc dynamic var name = ""
    @objc dynamic var number = ""
}

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var contacts: Results<Contact>!
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        setupSubviews()
        
        contacts = realm.objects(Contact.self)
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    private func setupSubviews(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func addTapped(){
        let alert = UIAlertController(title: "Add Contact", message: "Enter name and number", preferredStyle: .alert)
        alert.addTextField{ field in
            field.placeholder = "Name"
            field.returnKeyType = .next
            field.keyboardType = .namePhonePad
        }
        alert.addTextField{ field in
            field.placeholder = "Number"
            field.returnKeyType = .next
            field.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let fields = alert.textFields, fields.count == 2 else {
                return
            }
            let nameField = fields[0]
            let numberField = fields[1]
            guard let name1 = nameField.text , !name1 .isEmpty,
                  let number1 = numberField.text , !number1 .isEmpty else{
                      print("Incorrect data")
                      return
                  }
            let contact = Contact()
            contact.name = name1
            contact.number = number1
            
            try! self.realm.write {
                self.realm.add(contact)
                    }
            
            self.tableView.reloadData()
        }))
        
        present(alert, animated: true)
    }
    

}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contacts.count != 0{
            return contacts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let editingContact = contacts[indexPath.row]
            try! self.realm.write {
                self.realm.delete(editingContact)
                   }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootVC = DetailedVC()
        let contact = contacts[indexPath.row]
        let navVC = UINavigationController(rootViewController: rootVC)
        rootVC.nameField.text = contact.name
        rootVC.numberField.text = contact.number
        rootVC.title = contact.name
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell!
        
        if let cCell = tableView.dequeueReusableCell(withIdentifier: "cCell"){
            cell = cCell
        }else{
            cell = UITableViewCell()
        }
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        
        return cell
    }
}
