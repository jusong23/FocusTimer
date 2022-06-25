//
//  FoucsingTimeViewController.swift
//  Timer_Toy
//
//  Created by 이주송 on 2022/06/25.
//

import UIKit

class FoucsingTimeViewController: UIViewController {

    @IBOutlet weak var savedFocusTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTime()

    }
    
    func loadTime() {
    self.savedFocusTime.text = "최근 집중시간 " + (UserDefaults.standard.string(forKey: "max") ?? "0") + "초"
    }
//    @IBAction func goToSettingViewController(_ sender: Any) {
//        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") else { return }
//            self.navigationController?.pushViewController(viewController, animated: true)
//    }
}
