//
//  LoginViewController.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/12/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toaster

protocol ViewControllerRxBounding {
    func setupObservers()
}

class LoginViewController: UIViewController {
    fileprivate let viewModel: LoginViewModel
    fileprivate let bag = DisposeBag()
    
    // MARK: - UI Elements
    fileprivate var usernameTextField: UITextField = {
        var textfield = UITextField.loginTXF()
        textfield.placeholder = "Username" //FIXME: hardcoded
        return textfield
    }()
    
    fileprivate var passwordTextfield: UITextField = {
        var textfield = UITextField.loginTXF()
        textfield.isSecureTextEntry = true
        textfield.placeholder = "Password" // FIXME: hardcoded
        return textfield
    }()
    
    fileprivate var loginButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(red:0.78, green:0.36, blue:0.36, alpha:1.0)
        button.titleLabel?.textColor = .white
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var background: UIImageView = {
        var background = UIImageView(image: UIImage(named: "background"))
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    fileprivate var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.7
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        return loadingView
    }()
    
    fileprivate var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    fileprivate var connectingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    // MARK: - INIT
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle:nil)
    }
    
    // MARK: - View's method override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true
        setupUI()
        setupConstraints()
        setupObservers()
    }
    
    // MARK: - Setup UI and Constraints
    
    func setupUI() {
        view.addSubview(background)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextfield)
        view.addSubview(loginButton)
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(connectingLabel)
        loadingView.isHidden = true
        activityIndicator.center = self.view.center
        view.addSubview(loadingView)
    }
    
    func setupConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.width.equalTo(view).offset(-40)
            make.height.equalTo(60)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-60)
        }
        
        passwordTextfield.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(usernameTextField)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.centerX.height.equalTo(usernameTextField)
            make.top.equalTo(passwordTextfield.snp.bottom).offset(20)
        }
        
        
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(120)
            make.width.equalTo(120)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.center.equalTo(loadingView)
        }
        
        connectingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(loadingView)
            make.top.equalTo(activityIndicator.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginViewController: ViewControllerRxBounding {
    func setupObservers() {
        usernameTextField.rx.text.orEmpty.bind(to: viewModel.setUsername).disposed(by: bag)
        passwordTextfield.rx.text.orEmpty.bind(to: viewModel.setPassword).disposed(by: bag)
        loginButton.rx.tap.bind(to: viewModel.loginAttempt).disposed(by: bag)
        
        viewModel.loginButtonEnabled.asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.loadingHidden.asDriver(onErrorJustReturn: false)
            .drive(loadingView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.loadingHidden.asDriver(onErrorJustReturn: false)
            .map { !$0 }
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.loadingText.asDriver(onErrorJustReturn: "")
            .drive(connectingLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.logoutMsg.subscribe(onNext: { Toast(text: $0, duration: 3).show() }).disposed(by: bag)
    }
}
