//
//  SlidingButton.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/29/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

protocol SlidingButtonDelegate {
    func didTapSignInButton()
    func didTapCreateButton()
}

class SlidingButton: UIView {

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        return view
    }()
    
    //Delegate for sliding button
    var delegate: SlidingButtonDelegate?
    
    //Boolean to save state of sliding bar
    private var isSignIn = true
    
    //Animatable anchors
    private var centerSignAnchor: NSLayoutConstraint?
    private var centerCreateAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func didTapSignInButton() {
        if self.isSignIn != false { return }
        
        self.isSignIn = true
        self.delegate?.didTapSignInButton()
        
        self.centerSignAnchor?.isActive = true
        self.centerCreateAnchor?.isActive = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @objc private func didTapCreateButton() {
        if self.isSignIn != true { return }
        
        self.isSignIn = false
        self.delegate?.didTapCreateButton()
        
        self.centerSignAnchor?.isActive = false
        self.centerCreateAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

extension SlidingButton {
    private func setupView() {
        
        //Self
        self.backgroundColor = .systemGroupedBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //This is the frame of the parent view
        let viewFrame = UIScreen.main.bounds.width - 40
        
        //Target for buttons
        signInButton.addTarget(self, action: #selector(self.didTapSignInButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(self.didTapCreateButton), for: .touchUpInside)

        
        //Sign in button
        self.addSubview(self.signInButton)
        NSLayoutConstraint.activate([
            self.signInButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.signInButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.signInButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.signInButton.widthAnchor.constraint(equalToConstant: viewFrame / 2)
        ])
        
        
        //Create button
        self.addSubview(self.createButton)
        NSLayoutConstraint.activate([
            self.createButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.createButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            self.createButton.widthAnchor.constraint(equalToConstant: viewFrame / 2)
        ])
        
        //Add indicator view
        self.addSubview(self.indicatorView)
        
        self.centerSignAnchor = self.indicatorView.centerXAnchor.constraint(equalTo: self.signInButton.centerXAnchor)
        self.centerSignAnchor?.isActive = true
        
        self.centerCreateAnchor = self.indicatorView.centerXAnchor.constraint(equalTo: self.createButton.centerXAnchor)
        self.centerCreateAnchor?.isActive = false
        
        NSLayoutConstraint.activate([
            self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.indicatorView.heightAnchor.constraint(equalToConstant: 3),
            self.indicatorView.widthAnchor.constraint(equalToConstant: viewFrame / 4)
        ])
        
        
    }
}
