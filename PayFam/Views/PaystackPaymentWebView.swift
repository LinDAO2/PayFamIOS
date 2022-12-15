//
//  PaystackPaymentWebView.swift
//  PayFam
//
//  Created by Mattosha on 10/12/2022.
//

import SwiftUI
import WebKit

struct PaystackPaymentWebView: UIViewRepresentable {
    
    let url: URL?
    
    let callbackUrl = "CALLBACK_URL_GOES_HERE"
    let pstkUrl =  "AUTHORIZATION_URL_GOES_HERE"
    let ThreeDsUrl = "https://standard.paystack.co/close"
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs: WKWebpagePreferences = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else {
            return
        }
        let request = URLRequest(url: myURL)
        uiView.load(request)
    }
    
        //This is helper to get url params
      func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
      }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
            if(navigationAction.navigationType == .other) {
                if let redirectedUrl = navigationAction.request.url {
                    //do what you need with url
                    //self.delegate?.openURL(url: redirectedUrl)
                    print(redirectedUrl)
                }
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    
//  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
////      if(navigationAction.navigationType == .other) {
//          if let url = navigationAction.request.url {
//              print("url \(String(describing: url))")
//              /*
//               We control here when the user wants to cancel a payment.
//               By default a cancel action redirects to http://cancelurl.com/.
//               Based on our workflow we can for example remove the webview or push
//               another view to the user.
//               */
//              if url.absoluteString == "http://cancelurl.com/"{
//                  decisionHandler(.cancel)
//                  print("cancel")
//              }
//              else{
//                  decisionHandler(.allow)
//                  print("success")
//              }
//
//              //After a successful transaction we can check if the current url is the callback url
//              //and do what makes sense for our workflow. We can get the transaction reference for example.
//
//              if url.absoluteString.hasPrefix(callbackUrl){
//                  let reference = getQueryStringParameter(url: url.absoluteString, param: "reference")
//                  print("reference \(String(describing: reference))")
//              }
//          }
////      }
//
//        }
    
//    //This is helper to get url params
//  func getQueryStringParameter(url: String, param: String) -> String? {
//    guard let url = URLComponents(string: url) else { return nil }
//    return url.queryItems?.first(where: { $0.name == param })?.value
//  }
//
//
//    // This is a WKNavigationDelegate func we can use to handle redirection
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
//      decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void) ) {
//
//      if let url = navigationAction.request.url {
//
//        /*
//              We control here when the user wants to cancel a payment.
//              By default a cancel action redirects to http://cancelurl.com/.
//              Based on our workflow we can for example remove the webview or push
//              another view to the user.
//              */
//        if url.absoluteString == "http://cancelurl.com/"{
//          decisionHandler(.cancel)
//        }
//        else{
//          decisionHandler(.allow)
//        }
//
//              //After a successful transaction we can check if the current url is the callback url
//              //and do what makes sense for our workflow. We can get the transaction reference for example.
//
//          if url.absoluteString.hasPrefix(callbackUrl){
//          let reference = getQueryStringParameter(url: url.absoluteString, param: "reference")
//              print("reference \(String(describing: reference))")
//        }
//      }
//    }
    
}



struct PaystackPaymentWebView_Previews: PreviewProvider {
    static var previews: some View {
        PaystackPaymentWebView(url: URL(string: "https://google.com"))
    }
}
