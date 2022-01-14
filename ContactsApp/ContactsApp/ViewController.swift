import UIKit
import SnapKit

struct KeysDefaults{
    static let keyName = "name"
    static let keyNumber = "number"
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let defaults = UserDefaults.standard
    
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBase.shared.info.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootVC = DetailedVC()
        let navVC = UINavigationController(rootViewController: rootVC)
        rootVC.nameField.text = DataBase.shared.info[indexPath.row].name
        rootVC.numberField.text = DataBase.shared.info[indexPath.row].number
        rootVC.title = DataBase.shared.info[indexPath.row].name
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell!
        
        if let cCell = tableView.dequeueReusableCell(withIdentifier: "cCell"){
            cell = cCell
        }else{
            cell = UITableViewCell()
        }
        
        cell.textLabel?.text = DataBase.shared.info[indexPath.row].fullInfo
        
        return cell
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
            DataBase.shared.saveContact(name: name1, number: number1)
            self.tableView.reloadData()
        }))
        
        present(alert, animated: true)
    }
    
    
    
}

