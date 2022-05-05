//
//  AccountViewController.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SDWebImage
import DesignSystem
import AlertManager

protocol AccountViewInput: AnyObject {
    func setupInitialStateForCreate(stringFactory: AccountStringFactoryProtocol)
    func setupInitialStateForEdit(stringFactory: AccountStringFactoryProtocol)
    func setupFilledFields(info: AccountInfoViewModelProtocol)
    func setupRegion(info: String)
    func setLoading(on: Bool)
}

final class AccountViewController: UIViewController {
    var output: AccountViewOutput?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let helloLabel = UILabel()
    private let imageView = UIImageView()
    private let imageButton = UIButton()
    private let nameTextField = UITextField()
    private let nameLabel = UILabel()
    private let infoTextField = UITextField()
    private let infoLabel = UILabel()
    private let birthDayLabel = UILabel()
    private let birthDayTextfField = UITextField()
    private let countryCityLabel = UILabel()
    private let countryCityTextfField = UITextField()
    private let sexSegment = UISegmentedControl(items: ["",""])
    private let sexLabel = UILabel()
    private let birthDatePicker = UIDatePicker()
    private let enterButton = ButtonsFactory.blackLoadButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.layer.cornerRadius = imageView.layer.frame.size.height/2
    }
    
    @objc private func setImage() {
        self.presentImagePicker()
    }
    
    @objc func birthdayTapped() {
        birthDayTextfField.resignFirstResponder()
    }
    
    @objc private func enterTapped() {
        output?.sendAccountInfo(userName: nameTextField.text,
                                info: infoTextField.text,
                                sex: sexSegment.titleForSegment(at: sexSegment.selectedSegmentIndex),
                                userImage: imageView.image,
                                birthday: birthDayTextfField.text,
                                countryCity: countryCityTextfField.text)
    }
    
}

extension AccountViewController: AccountViewInput {

    func setupInitialStateForCreate(stringFactory: AccountStringFactoryProtocol) {
        setupFirstResponders()
        setupScrollView()
        setupViewsForCreate(stringFactory: stringFactory)
        setupConstraints()
        setupActions()
        addKeyboardObservers()
        addGesture()
    }
    
    func setupInitialStateForEdit(stringFactory: AccountStringFactoryProtocol) {
        setupFirstResponders()
        setupScrollView()
        setupViewsForEdit(stringFactory: stringFactory)
        setupConstraints()
        setupActions()
        addKeyboardObservers()
        addGesture()
    }
    
    func setupFilledFields(info: AccountInfoViewModelProtocol) {
        nameTextField.text = info.displayName
        infoTextField.text = info.info
        countryCityTextfField.text = info.countryCity
        birthDayTextfField.text = info.birthday
        birthDatePicker.date = info.birthdayDate
        sexSegment.selectedSegmentIndex = info.sexIndex
        imageView.sd_setImage(with: info.photoURL)
    }
    
    func setupRegion(info: String) {
        countryCityTextfField.text = info
    }
    
    func setLoading(on: Bool) {
        DispatchQueue.main.async {
            on ? self.enterButton.loading() : self.enterButton.stop()
        }
    }
}

private extension AccountViewController {
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setupActions() {
        enterButton.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        birthDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)),
                                  for: .valueChanged)
    }
    
    func setupViewsForCreate(stringFactory: AccountStringFactoryProtocol) {
        helloLabel.font = UIFont.avenir26()
        imageView.image = UIImage(named: stringFactory.imageDefaultName, in: Bundle.module, compatibleWith: nil)
        imageButton.setImage(UIImage(named: stringFactory.buttonImageDefaultName, in: Bundle.module, compatibleWith: nil), for: .normal)
        nameLabel.text = stringFactory.nameTitleText
        infoLabel.text = stringFactory.infoTitleText
        birthDayLabel.text = stringFactory.birthdayTitleText
        countryCityLabel.text = stringFactory.regionTitleText
        sexSegment.setTitle(stringFactory.maleTitleText, forSegmentAt: 0)
        sexSegment.setTitle(stringFactory.femaleTitleText, forSegmentAt: 1)
        sexSegment.selectedSegmentIndex = 0
        sexLabel.text = stringFactory.sexTitleText
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = stringFactory.createTitle
        helloLabel.text = stringFactory.subtitle
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        scrollView.backgroundColor = .white
        enterButton.setTitle(stringFactory.createButtonTitle, for: .normal)
        helloLabel.textAlignment = .center
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.3
        imageView.layer.borderColor = UIColor.buttonDark().cgColor
    }
    
    func setupViewsForEdit(stringFactory: AccountStringFactoryProtocol) {
        helloLabel.font = UIFont.avenir26()
        imageView.image = UIImage(named: stringFactory.imageDefaultName)
        imageButton.setImage(UIImage(named: stringFactory.buttonImageDefaultName), for: .normal)
        nameLabel.text = stringFactory.nameTitleText
        infoLabel.text = stringFactory.infoTitleText
        birthDayLabel.text = stringFactory.birthdayTitleText
        countryCityLabel.text = stringFactory.regionTitleText
        sexSegment.setTitle(stringFactory.maleTitleText, forSegmentAt: 0)
        sexSegment.setTitle(stringFactory.femaleTitleText, forSegmentAt: 1)
        sexLabel.text = stringFactory.sexTitleText
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = stringFactory.editTitle
        helloLabel.text = stringFactory.subtitle
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        scrollView.backgroundColor = .white
        enterButton.setTitle(stringFactory.editButtonTitle, for: .normal)
        helloLabel.textAlignment = .center
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1.3
        imageView.layer.borderColor = UIColor.buttonDark().cgColor
    }

    func setupConstraints() {
        let nameView = UIView(textField: nameTextField, label: nameLabel, spacing: 15)
        let infoView = UIView(textField: infoTextField, label: infoLabel, spacing: 15)
        let birthView = UIView(textField: birthDayTextfField, label: birthDayLabel, spacing: 15)
        let countryCityView = UIView(textField: countryCityTextfField, label: countryCityLabel, spacing: 15)
        let sexView = UIView(segment: sexSegment, label: sexLabel, spacing: 15)
        let imageButtonView = UIView(imageView: imageView, button: imageButton)
        let enterStack = UIStackView(arrangedSubviews: [nameView,infoView,birthView,countryCityView,sexView,enterButton], spacing: 15, axis: .vertical)
        
        contentView.addSubview(helloLabel)
        contentView.addSubview(imageButtonView)
        contentView.addSubview(enterStack)
        
        helloLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        helloLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 40).isActive = true
        
        imageButtonView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor,constant: 15).isActive = true
        imageButtonView.leadingAnchor.constraint(equalTo: enterStack.leadingAnchor,constant: 70).isActive = true
        imageButtonView.trailingAnchor.constraint(equalTo: enterStack.trailingAnchor,constant: -30).isActive = true
        imageButtonView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        enterStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        enterStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
        enterStack.topAnchor.constraint(equalTo: imageButtonView.bottomAnchor, constant: 15).isActive = true
        enterStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15).isActive = true
        enterStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}

private extension AccountViewController {
    func setupFirstResponders() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(birthdayTapped))
        toolBar.setItems([doneButton], animated: true)
        birthDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            birthDatePicker.preferredDatePickerStyle = .wheels
        }
        birthDayTextfField.inputView = birthDatePicker
        birthDayTextfField.inputAccessoryView = toolBar
    }
    
    func addGesture() {
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        countryCityTextfField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryCityTapped)))
    }
    
    @objc func countryCityTapped() {
        view.endEditing(true)
        output?.countryCitySelection()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func datePickerChangedValue(sender: UIDatePicker) {
        self.birthDayTextfField.text = output?.birthdateText(value: sender.date)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        scrollView.contentSize.height = contentView.frame.height
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollView.contentOffset.y = keyboardHeight - 40
            scrollView.contentSize.height += keyboardHeight
        }
    }
}

extension AccountViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
}
