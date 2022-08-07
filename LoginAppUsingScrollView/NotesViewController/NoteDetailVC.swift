//
//  NoteDetailVC.swift
//  LoginAppUsingScrollView
//
//  Created by Admin on 31/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class NoteDetailVC: UIViewController {
    
    // Properties
    
    let descriptionTextView = UITextView()
    
    var completion: ((Notes) -> Void)?
    
    var selectedNote: Notes? = nil
    
    //var note: Notes?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureRightBarButton()
        setUpConstraint()
        configureTextView()
        configureDeleteButton()
        setDetails()
    }
    
    // Init
    
    let titleLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        lable.numberOfLines = 0
        lable.text = "Title"
        lable.textAlignment = .center
        return lable
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textField.backgroundColor = .secondarySystemBackground
        textField.placeholder = "Enter title"
        return textField
    }()
    
    let descriptionLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        lable.numberOfLines = 0
        lable.text = "Description"
        lable.textAlignment = .center
        return lable
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget((Any).self, action: #selector(deleteSelectedNote), for: .touchUpInside)
        return button
    }()
    
    func configureDeleteButton() {
        deleteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 50).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpConstraint() {
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLable)
        view.addSubview(titleTextField)
        view.addSubview(deleteButton)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        titleTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        descriptionLable.topAnchor.constraint(equalTo: titleTextField.topAnchor, constant: 60).isActive = true
        descriptionLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        descriptionLable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
    }
    
    
    func configureTextView()  {
        
        descriptionTextView.font = .systemFont(ofSize: 18)
        descriptionTextView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        [
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLable.topAnchor, constant: 30),
            descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 250),
        ].forEach{
            $0.isActive = true
        }
    }
    
    
    func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNotes))
    }
    
    
    // Save Notes
    
    @objc func saveNotes() {
        
        if let text = titleTextField.text, !text.isEmpty || !descriptionTextView.text.isEmpty {
            
            guard let noteTitle = titleTextField.text,
                    let noteDesc = descriptionTextView.text else { return }
            
            if selectedNote != nil {
                self.updateNote()
            }
            else {
                NoteService.shared.createNote(title: noteTitle, describe: noteDesc) { error in
                    
                    // todo
                    if error != nil {self.isNoteSaveAlert()}
                    // main thred
                    else {self.navigationController?.popViewController(animated: true)}
                }
            }
        }
        else{self.isEmptyTextFieldAlert()}
    }
    
    
    
    // Delete Note
    
    @objc func deleteSelectedNote() {
        
        guard let noteId = selectedNote?.id else {
            
            print("Id not found")
            self.isDeleteAlert()
            return
        }
        NoteService.shared.deleteNote(id: noteId) { isSuccess in
            if isSuccess {self.navigationController?.popViewController(animated: true)}
        }
    }
    
    
    // Update Note
    
    func updateNote() {
        
        guard
            let noteId = selectedNote?.id as? String,
            let noteTitle = titleTextField.text,
            let noteDesc = descriptionTextView.text else { return }
        
        NoteService.shared.updateNotes(id: noteId, title: noteTitle, desc: noteDesc) { isSuccess in
            if isSuccess {self.navigationController?.popViewController(animated: true) }
        }
        print("one")
    }
    
    
    // Mark : Alert
    
    func isDeleteAlert() {
        let deleteAlert = UIAlertController(title: "Can't Delete", message: "First save note after then you can delete it", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func isEmptyTextFieldAlert() {
        let isTextAvailable = UIAlertController(title: "Input Field Is Empty", message: "Please enter somethimg then save it", preferredStyle: .alert)
        isTextAvailable.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(isTextAvailable, animated: true, completion: nil)
        return
    }
    
    func isNoteSaveAlert() {
        let noteSaveAleart = UIAlertController(title: "Something Wrong", message: "Can't save right now try again", preferredStyle: .alert)
        noteSaveAleart.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(noteSaveAleart, animated: true, completion: nil)
    }
    
    
    // Mark : set Detail of text
    
    func setDetails() {

        if (selectedNote != nil) {
            titleTextField.text = selectedNote?.title
            descriptionTextView.text = selectedNote?.desc
        }
    }
}
