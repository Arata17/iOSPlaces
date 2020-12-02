//
//  EditWayPointVC.swift
//  Places
//
//  Created by Мирас on 11/3/20.
//

import UIKit
protocol EditAnnotationInfoProtocol {
    func editAnnotation(title: String, subTitle: String)
}

class EditWayPointVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subTitleTextField: UITextField!
    
    var titleText: String?
    var subTitle: String?
    var delegate: EditAnnotationInfoProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = titleText
        subTitleTextField.text = subTitle
    }
    

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.editAnnotation(title: titleTextField.text!, subTitle: subTitleTextField.text!)
        navigationController?.popViewController(animated: true)
    }
    

}
