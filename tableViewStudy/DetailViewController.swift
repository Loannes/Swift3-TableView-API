//
//  DetailViewController.swift
//  tableViewStudy
//
//  Created by Stripes.sin on 2016. 9. 6..
//  Copyright © 2016년 Loannes. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var navibar: UINavigationItem!
    @IBOutlet weak var wv: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var mvo : MovieVO? = nil
    
    override func viewDidLoad() {
        NSLog("linkurl = \(self.mvo?.detail), title=\(self.mvo?.title)")
        
        self.navibar.title = self.mvo?.title
        
        if let url = self.mvo?.detail {
//            if let urlObj = NSURL(string: url) {
            if let urlObj = URL(string: "https:stripes.co.kr") {
                let req = URLRequest(url: urlObj)
                self.wv.loadRequest(req)
            } else { // URL 형식이 잘못되었을 경우에 대한 예외 처리
                
                // 경고창 형식으로 오류 메시지를 표시해준다
                let alert = UIAlertController(title: "error", message: "잘못된 주소입니다", preferredStyle: .alert)
                
                let cancleAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(cancleAction)
                self.present(alert, animated: false, completion: nil)
                
            }
        } else { // URL 값이 전달되지 않았을때에 대한 예외처리
            
            // 경고창 형식으로 오류 메시지를 표시해준다
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                //이전 페이지로 되돌림
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
            
        }
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.spinner.stopAnimating()
        
        // 경고창 형식으로 오류 메시지를 표시해준다
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다", preferredStyle: .alert)
        
        let cancelActon = UIAlertAction(title: "확인", style: .cancel) { (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelActon)
        self.present(alert, animated: false, completion: nil)
    }
}
