import Foundation
import SnapKit

class DetailedVC: UIViewController {
    
    private lazy var name1: UILabel = {
        let view = UILabel()
        view.text = "Name:"
        view.textColor = .black
        return view
    }()
    
    private lazy var number1: UILabel = {
        let view = UILabel()
        view.text = "Number:"
        view.textColor = .black
        return view
    }()
    
    lazy var nameField: UILabel = {
        let view = UILabel()
        return view
    }()
    
    lazy var numberField: UILabel = {
        let view = UILabel()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews(){
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(name1)
        name1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.frame.height / 10)
            make.left.equalToSuperview()
            make.height.equalToSuperview().dividedBy(15)
            make.width.equalToSuperview().dividedBy(2)
        }
        view.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.top.equalTo(name1.snp.bottom).offset(view.frame.height / 40)
            make.height.equalToSuperview().dividedBy(15)
            make.width.equalToSuperview().dividedBy(2)
        }
        view.addSubview(number1)
        number1.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(view.frame.height / 40)
            make.height.equalToSuperview().dividedBy(15)
            make.width.equalToSuperview().dividedBy(2)
        }
        view.addSubview(numberField)
        numberField.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(view.frame.height / 40)
            make.height.equalToSuperview().dividedBy(15)
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
}
