//
//  InputTextView.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

protocol InputTextViewDelegate {
    func didTapSendButton(text: String)
    func didTapMoreButton()
    func textViewDidChangeHeight(height: CGFloat)
}

class InputTextView: UIView {
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return view
    }()
    
    private let inputTextview: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 16)
        field.showsHorizontalScrollIndicator = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var delegate: InputTextViewDelegate?
    private var previousRect = CGRect.zero
    private var heightChangeCount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.inputTextview.delegate = self
        
        //Setup separator view
        self.addSubview(self.separatorView)
        NSLayoutConstraint.activate([
            self.separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.separatorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.separatorView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        //Setup plus button
        self.addSubview(self.moreButton)
        NSLayoutConstraint.activate([
            self.moreButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.moreButton.heightAnchor.constraint(equalToConstant: 40),
            self.moreButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        //Setup input textfield
        self.addSubview(self.inputTextview)
        NSLayoutConstraint.activate([
            self.inputTextview.leftAnchor.constraint(equalTo: self.moreButton.rightAnchor, constant: 5),
            self.inputTextview.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.inputTextview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.inputTextview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40)
        ])
        
        //Setup send button
        self.addSubview(self.sendButton)
        NSLayoutConstraint.activate([
            self.sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            self.sendButton.heightAnchor.constraint(equalToConstant: 40),
            self.sendButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        //Targets
        self.sendButton.addTarget(self, action: #selector(self.didTapSendButton), for: .touchUpInside)
        self.moreButton.addTarget(self, action: #selector(self.didTapMoreButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func didTapSendButton() {
        guard let text = self.inputTextview.text else { return }
        self.delegate?.didTapSendButton(text: text)
        
        self.previousRect = CGRect.zero
        self.heightChangeCount = 0
        self.inputTextview.text = ""
    }
    
    @objc private func didTapMoreButton() {
        self.delegate?.didTapMoreButton()
    }
    
}

extension InputTextView: UITextViewDelegate {
    internal func textViewDidChange(_ textView: UITextView) {
        
        let currentRect = textView.caretRect(for: textView.endOfDocument)
        
        if currentRect.origin.y > previousRect.origin.y {
            if self.heightChangeCount >= 4 { return }
            self.delegate?.textViewDidChangeHeight(height: 16)
            self.heightChangeCount += 1
        } else if  currentRect.origin.y < previousRect.origin.y {
            self.delegate?.textViewDidChangeHeight(height: -16)
            self.heightChangeCount -= 1
        }
        
        self.previousRect = currentRect
    }
}
