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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTime()
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
//        debugPrint(servedArray)

//        servedArray?.removeAll()
// max를 리무브 올해주기 0으로 초기화 하든
        debugPrint(UserDefaults.standard.integer(forKey: "max"))
        debugPrint(UserDefaults.standard.integer(forKey: "sum"))
//        debugPrint(servedArray)
// 여기서 총합이 0이 된 servedArray를 maxArray를 앞쪽 뷰컨에 저장해줘야함
// total 배열에 저장된 값도 지워야함
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let viewController = segue.destination as? ViewController {
              viewController.maxFocusTime = [4,9,4,8]
          }
  }
}

// 오늘의 집중시간 초기화를 눌렀을 때 초기화가 안됨
// 공부 끝 ! 했을때 까지는 유저디폴트 sum이 0으로 초기화 but, 처음 화면으로 돌아가면 maxFocusTime에 [2,4] 등 이전 값이 저장되어 있으므로 유저디포트에 덧대어 저장되는것
// ---> 공부 끝 ! 눌렀을 때 maxFocusTime도 0으로 초기화 해야한다.
// test 1 2 3 
