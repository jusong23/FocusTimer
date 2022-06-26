//
//  FoucsingTimeViewController.swift
//  Timer_Toy
//
//  Created by 이주송 on 2022/06/25.
//

import UIKit

class FoucsingTimeViewController: UIViewController {

    @IBOutlet weak var savedFocusTime: UILabel!
    @IBOutlet weak var sumOfTodaysFocusTime: UILabel!
    @IBOutlet weak var resetAndSaveSumOfTodaysFocusTime: UIButton!
    
    var servedArray:[Int]? = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTime()
        if let name = servedArray {
                debugPrint("it`s worging \(name)")
        }
    }
    
    
    func loadTime() {
    self.savedFocusTime.text = "최근 집중시간 " + (UserDefaults.standard.string(forKey: "max") ?? "0") + "초"
    }

    @IBAction func checkToSumOfTodaysFocusTime(_ sender: Any) {
        self.sumOfTodaysFocusTime.isHidden = false
        self.resetAndSaveSumOfTodaysFocusTime.isHidden = false
        debugPrint(UserDefaults.standard.integer(forKey: "sum"))
        self.sumOfTodaysFocusTime.text = String(UserDefaults.standard.integer(forKey: "sum")) + "초"
    }
    
    @IBAction func resetAndSaveSumOfTodaysFocusTime(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "max")
        UserDefaults.standard.removeObject(forKey: "sum")
        
        debugPrint(UserDefaults.standard.integer(forKey: "max"))
        debugPrint(UserDefaults.standard.integer(forKey: "sum"))
        servedArray?.removeAll()
        // 여기서 총합이 0이 된 servedArray를 maxArray를 앞쪽 뷰컨에 저장해줘야함
// total 배열에 저장된 값도 지워야함
    }
}

// 오늘의 집중시간 초기화를 눌렀을 때 초기화가 안됨
