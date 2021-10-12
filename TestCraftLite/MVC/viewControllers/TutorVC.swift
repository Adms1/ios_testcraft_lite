//
//  TutorVC.swift
//  TestCraftLite
//
//  Created by ADMS on 06/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import SDWebImage

class TutorVC: UIViewController ,ActivityIndicatorPresenter,UITextFieldDelegate{
    
    var activityIndicatorView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var imgView = UIImageView()

    var arrTutorList = [arrTutorModel]()
    var search:String=""
    var SearchData = [arrTutorModel]()

    @IBOutlet weak var tblTutorList:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblNoDataFound:UILabel!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var btnFilter:UIButton!
    @IBOutlet weak var searchText: UITextField!
    var searchArrRes = [arrTutorModel]()
    var searching:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Curator"
        searchText.delegate = self
        strCategoryID1 = ""
        strCategoryID2 = ""
        strCategoryID3 = ""

        tblTutorList.delegate = self
        tblTutorList.dataSource = self

        searchText.setLeftPaddingPoints(10)


//        btnFilter.layer.cornerRadius = 6.0
//        btnFilter.layer.masksToBounds = true
//
//        btnFilter.layer.borderWidth = 0.5
//        btnFilter.layer.borderColor = UIColor.lightGray.cgColor


    }
    override func viewWillAppear(_ animated: Bool) {
        api_Call_Get_Tutor()
    }

    @IBAction func btnClickBack(){
        self.navigationController?.popViewController(animated: true)
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//       textField.resignFirstResponder()
//       return true
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.dropLast())
        }
        else
        {
            search=textField.text!+string
        }

        print(search)
       // let predicate=NSPredicate(format: "SELF.TutorName CONTAINS[cd] %@", search)
        let arr = self.arrTutorList.filter({(($0.TutorName).localizedCaseInsensitiveContains(search))})

        if arr.count > 0
        {
            SearchData.removeAll(keepingCapacity: true)
            SearchData = arr
        }
        else
        {
            SearchData=arrTutorList
        }
        tblTutorList.reloadData()
        return true
    }


//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//
////        if textField.text!.count < 0{
//////            arrTutorList.removeAll()
////            searching = false
////        }else{
//            let searchText  = textField.text! + string
//           //add matching text to arrya
//              searchArrRes = self.arrTutorList.filter({(($0.TutorName).localizedCaseInsensitiveContains(searchText))})
//
//           if(searchArrRes.count == 0){
//             searching = false
//           }else{
//             searching = true
//          }
//      //  }
//
//      //input text
//
//     self.tblTutorList.reloadData()
//
//     return true
//   }

//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
//            let string1 = string
//            let string2 = searchText.text
//            var finalString = ""
//            if string.count > 0 { // if it was not delete character
//                finalString = string2! + string1
//            }
//            else if string2!.count > 0{ // if it was a delete character
//
//                finalString = String(string2!.dropLast())
//             }
//        filteredArray(searchString: finalString as NSString)// pass the search String in this method
//            return true
//        }

//    func filteredArray(searchString:NSString){// we will use NSPredicate to find the string in array
//            let predicate = NSPredicate(format: "SELF contains[c] %@",searchString) // This will give all element of array which contains search string
//            //let predicate = NSPredicate(format: "SELF BEGINSWITH %@",searchString)// This will give all element of array which begins with search string (use one of them)
//        arrTutorList = arrTutorList.filteredArrayUsingPredicate(predicate)
//            print(filteredArray)
//       }


    @IBAction func btnFilterClicked(){
        api_Activity_Action(Type: "1", gameid: "", gamesessionid: "\(UserDefaults.standard.value(forKey: "TrackTokenID") ?? "")", actionid: "901", comment: "Filter", isFirstTime: "0")

        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }


    

}
extension TutorVC:UITableViewDelegate,UITableViewDataSource{
    //MARK:Tableview Delegates and Datasource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if( searching == true){
              return SearchData.count
//           }else{
//              return arrTutorList.count
//           }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->  CGFloat {
        return 115
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorCell", for: indexPath) as! TutorCell

        cell.imgTutor.layer.cornerRadius = cell.imgTutor.layer.frame.width/2.0
        cell.imgTutor.layer.masksToBounds = true


//        if( searching == true){
            cell.imgTutor.sd_setImage(with: URL(string: API.imageUrl + SearchData[indexPath.row].Icon))

            // tempory hide InstituteName

          //  cell.lblBoard.text = arrTutorList[indexPath.row].InstituteName
            cell.lblTutorNAme.text = SearchData[indexPath.row].TutorName

            // tempory hide TutorPhoneNumber
         //   cell.lblSubject.text = arrTutorList[indexPath.row].TutorPhoneNumber

            cell.vwStarRating.isHidden = false
            cell.vwStarRating.rating = SearchData[indexPath.row].TutorStars
        cell.vwStarRating.settings.updateOnTouch = false
        cell.vwStarRating.settings.starMargin = 1
            cell.selectionStyle = .none

            cell.cellVw.layer.cornerRadius = 6.0
            cell.cellVw.layer.masksToBounds = true

//        }else{
//            cell.imgTutor.sd_setImage(with: URL(string: API.imageUrl + arrTutorList[indexPath.row].Icon))
//
//            // tempory hide InstituteName
//
//          //  cell.lblBoard.text = arrTutorList[indexPath.row].InstituteName
//            cell.lblTutorNAme.text = arrTutorList[indexPath.row].TutorName
//
//            // tempory hide TutorPhoneNumber
//         //   cell.lblSubject.text = arrTutorList[indexPath.row].TutorPhoneNumber
//
//            cell.vwStarRating.isHidden = false
//            cell.vwStarRating.rating = arrTutorList[indexPath.row].TutorStars
//            cell.selectionStyle = .none
//
//            cell.cellVw.layer.cornerRadius = 6.0
//            cell.cellVw.layer.masksToBounds = true
//
//        }

      //  cell.imgTutor.sd_setImage(with: URL(string: API.imageUrl + arrTutorList[indexPath.row].Icon))

        


        //cell.myCollView.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TutorDetailVC") as? TutorDetailVC
        vc?.tutorId = SearchData[indexPath.row].TutorID
        self.navigationController?.pushViewController(vc!, animated: true)

    }
}
extension TutorVC{
    func api_Call_Get_Tutor()
    {
                showActivityIndicator()
                self.arrTutorList.removeAll()
        self.SearchData.removeAll()

        // let params = [:]
        var params = ["":""]
        var int_count = 0
        btnFilter.isHidden = false
       // lblFilterCount.isHidden = false
//            Get_TutorNameBy_Criteria_Lite(string CourseTypeID, string BoardID, string CourseID, string StandardID, string SubjectID)


        if UserDefaults.standard.bool(forKey: "isFilterApply") == false
        {
            params = ["CourseTypeID":"","BoardID":"","CourseID":"","StandardID":"","SubjectID":""]
        }
        else{


            //            isFilterApply = ""
            if strCategoryID == "1" {
                //            params = ["BoardID":strCategoryID1,"StandardID":strCategoryID2,"CourseTypeID": strCategoryID,"SubjectID":strCategoryID3,"TutorID":strTutorsId] //OLD
                params = ["CourseTypeID":"1","BoardID":strCategoryID1,"CourseID":"","StandardID":strCategoryID2,"SubjectID":strCategoryID3]
                //            params = ["BoardID":"","StandardID":"","CourseTypeID": "","SubjectID":"","TutorID":"","CourseID":"","FromPrice":"","ToPrice":"","Name":""]
                //            if strCategoryID != ""{int_count = int_count + 1}
                if strCategoryID1 != ""{int_count = int_count + 1}
                if strCategoryID2 != ""{int_count = int_count + 1}
                if strCategoryID3 != ""{int_count = int_count + 1}
                if strTutorsId != ""{int_count = int_count + 1}
                if strMinPrice != "" || strMaxPrice != ""{int_count = int_count + 1}

            }
            else
            {
                //            params = ["BoardID":"0","StandardID":"0","CourseTypeID": strCategoryID,"SubjectID":strCategoryID3,"TutorID":strTutorsId]//OLD
                params = ["BoardID":"","StandardID":"","CourseTypeID": "2","SubjectID":"","CourseID":strCategoryID1]
                if strCategoryID1 != ""{int_count = int_count + 1}
                if strCategoryID3 != ""{int_count = int_count + 1}
                if strTutorsId != ""{int_count = int_count + 1}
                if strMinPrice != "" || strMaxPrice != ""{int_count = int_count + 1}
            }

        }





        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        //Bhargav Hide
        //        print("API, Params: \n",API.Get_Course_ListApi,params)
        if !Connectivity.isConnectedToInternet() {
            //            self.AlertPopupInternet()

            // show Alert
                                       self.hideActivityIndicator()
            print("The network is not reachable")
            self.tblTutorList.reloadData()
            // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
            return
        }
//        Get_TutorNameBy_Criteria_Lite(string CourseTypeID, string BoardID, string CourseID, string StandardID, string SubjectID)
        Alamofire.request(API.Get_Tutor_By_Filter, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()

            switch response.result {
            case .success(let value):

                let json = JSON(value)
                //Bhargav Hide
                print(json)
             //   self.arrPreferenceList.removeAll()
                if(json["Status"] == "true" || json["Status"] == "1") {
                    if let arrData = json["data"].array{
                        for (_,value) in arrData.enumerated() {

                            let objdict = arrTutorModel(
                                TutorID: value["TutorID"].intValue, TutorName: value["TutorName"].stringValue, TutorEmail: value["TutorEmail"].stringValue, TutorPhoneNumber: value["TutorPhoneNumber"].stringValue, InstituteName: value["InstituteName"].stringValue, Icon: value["Icon"].stringValue, TotalRateCount: value["TutorStars"].stringValue, TutorStars: value["TutorStars"].doubleValue, TutorDescription: value["TutorDescription"].stringValue)
                            self.arrTutorList.append(objdict)
                        }
                    }
                    self.SearchData = self.arrTutorList
                    self.tblTutorList.isHidden = false
                    self.lblNoDataFound.isHidden = true
                    DispatchQueue.main.async {
                        self.tblTutorList.reloadData()
                    }
                }
                else
                {
                    self.tblTutorList.isHidden = true
                    self.lblNoDataFound.isHidden = false
//                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//                    label.center = CGPoint(x: 160, y: 284)
//                    label.textAlignment = .center
                    self.lblNoDataFound.text = "No Tutor Found"
//                    self.view.addSubview(label)

                    self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
        }
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
