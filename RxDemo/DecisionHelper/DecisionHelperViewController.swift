//
//  DecisionHelperViewController.swift
//  RxDemo
//
//  Created by Jean-Michel Barbieri on 5/12/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DecisionHelperViewController: UIViewController {
    fileprivate let viewModel: DecisionHelperViewModel
    fileprivate let bag = DisposeBag()
    fileprivate var background: UIImageView = {
        var background = UIImageView(image: UIImage(named: "background"))
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    fileprivate var famillyDinerLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Family dinner?"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    
    fileprivate var niceWeatherLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nice weather?"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    
    fileprivate var duringWeekendLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "During a weekend?"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    
    fileprivate var moodImage: UIImageView = {
        var img = UIImageView(image: UIImage(named: "sad"))
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    fileprivate var logoutButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(red:0.78, green:0.36, blue:0.36, alpha:1.0)
        button.titleLabel?.textColor = .white
        button.setTitle("LOGOUT", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let familyValue = UISwitch()
    fileprivate let niceWeatherValue = UISwitch()
    fileprivate let duringWeekendValue = UISwitch()
    
    // MARK: - INIT
    init(viewModel: DecisionHelperViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle:nil)
    }
    
    // MARK: - View's method override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupObservers()
    }
    
    // MARK: - Setup UI and Constraints
    
    func setupUI() {
        self.navigationController!.navigationBar.isHidden = true
        view.addSubview(background)
        view.addSubview(famillyDinerLabel)
        view.addSubview(niceWeatherLabel)
        view.addSubview(duringWeekendLabel)
        view.addSubview(familyValue)
        view.addSubview(niceWeatherValue)
        view.addSubview(duringWeekendValue)
        view.addSubview(moodImage)
        view.addSubview(logoutButton)
    }
    
    func setupConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        famillyDinerLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(60)
        }
        familyValue.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-20)
            make.centerY.equalTo(famillyDinerLabel)
        }
        niceWeatherLabel.snp.makeConstraints { make in
            make.left.equalTo(famillyDinerLabel)
            make.top.equalTo(famillyDinerLabel.snp.bottom).offset(20)
        }
        niceWeatherValue.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-20)
            make.centerY.equalTo(niceWeatherLabel)
        }
        duringWeekendLabel.snp.makeConstraints { make in
            make.left.equalTo(famillyDinerLabel)
            make.top.equalTo(niceWeatherLabel.snp.bottom).offset(20)
        }
        duringWeekendValue.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-20)
            make.centerY.equalTo(duringWeekendLabel)
        }
        moodImage.snp.makeConstraints { make in
            make.height.width.equalTo(200)
            make.center.equalTo(view)
        }
        logoutButton.snp.makeConstraints { make in
            make.width.equalTo(view).offset(-40)
            make.height.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(moodImage.snp.bottom).offset(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DecisionHelperViewController: ViewControllerRxBounding {
    func setupObservers() {
        familyValue.rx.isOn.bind(to: viewModel.setFamillyDinner).disposed(by: bag)
        niceWeatherValue.rx.isOn.bind(to: viewModel.setGoodWeather).disposed(by: bag)
        duringWeekendValue.rx.isOn.bind(to: viewModel.setDuringWeekend).disposed(by: bag)
        logoutButton.rx.tap.bind(to: viewModel.logout).disposed(by: bag)
        
        viewModel.imageTitle.asObservable()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { imageName in
                self.moodImage.image = UIImage(named: imageName)
            })
            .disposed(by: bag)
    }
}
