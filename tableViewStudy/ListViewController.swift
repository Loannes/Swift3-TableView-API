//
//  ListViewController.swift
//  tableViewStudy
//
//  Created by Loannes on 2016. 9. 4..
//  Copyright © 2016년 Loannes. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {

    var list = Array<MovieVO>()
    var page = 1

    @IBOutlet var movieTable: UITableView!
    @IBOutlet weak var moreBtn: UIButton!

    @IBAction func more(_ sender: AnyObject) {
        self.page += 1
        
        self.callMovieAPI()
        
        self.movieTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        
        self.callMovieAPI()
        
    }
    
    
    
    // API 서버로부터 데이터를 받아와 데이터 셋에 넣는다
    func callMovieAPI() {
        let apiURI = URL(string: "http://apis.skplanetx.com/hoppin/movies?order=releasedateasc&count=10&page=\(self.page)&genreID=&version=1&appKey=4c076579-9197-3e63-a809-6256fd2027d3")
        
        let apidata : Data? = try? Data(contentsOf: apiURI!)
        
        // NSLog("API Result=%@", NSString(data: apidata!, encoding:  String.Encoding.utf8.rawValue)!)
        
        // json으로 데이터를 파싱할때는 예외구문을 쓴다.
        // 만일 서버 네트워크가 끈기거나 오류가 발생할 경우 예외처리를 해야한다
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata!, options: []) as! NSDictionary
            
            if let hoppin = apiDictionary["hoppin"] as? NSDictionary {
                let movies = hoppin["movies"] as! NSDictionary
                let movie = movies["movie"] as! NSArray
                
                var mvo : MovieVO
                
                for row in (movie as? [[String:Any]])! {
                    mvo = MovieVO()
                    
                    mvo.title = row["title"] as? String
                    mvo.description = row["genereNames"] as? String
                    mvo.thumbnail = row["thumbnailImage"] as? String
                    mvo.detail = row["linkUrl"] as? String
                    mvo.rating = (row["ratingAverage"] as? NSString)!.floatValue
                    
                    self.list.append(mvo)
                }
            }
            
            let mvo = MovieVO()
            
            mvo.title = "temp title"
            mvo.description = "temp description"
            mvo.thumbnail = "http://img.4k-wallpaper.net/medium/yoga-pose-at-sunlight_325.jpeg"
            mvo.detail = "http://???"
            mvo.rating = 7.0
            
            self.list.append(mvo)
            self.list.append(mvo)
            self.list.append(mvo)
            self.list.append(mvo)
            self.list.append(mvo)
            
            
        } catch {
            //NSLog("Parse Error!!")
        }
        
        
        //        let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
        let totalCount = 20
        
        if (self.list.count >= totalCount) {
            self.moreBtn.isHidden = true
        }
    }

    
    // 썸네일을 만든다
    func getThumbnailImage(_ index : Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        // 메모이제이션 처리 : 저장된 이미지가 있을 경우 이를 반환하고, 없을 경우 내려받아 저장한 후 반환함
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url = URL(string: mvo.thumbnail!)
            let imageData = try? Data(contentsOf: url!)
            mvo.thumbnailImage = UIImage(data: imageData!) // UIImage 객체를 생성하여 movieVO객체에 우선 저장함
            
            return mvo.thumbnailImage!
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - Talble View delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        // 썸네일은 비동기 방식으로 가져온다
        DispatchQueue.main.async(execute: {
                cell.thumbnail.image = self.getThumbnailImage((indexPath as NSIndexPath).row)
        })

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Touch Table Row at %d", (indexPath as NSIndexPath).row)
    }
    
    
    
    // MARK: - Segue 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let path  = self.movieTable.indexPathForCell(sender as! MovieCell)
//        (segue.destinationViewController as? DetailViewController)?.mvo = self.list[path!.row]
        
        // 실행된 세그의 식별자가 아래와 같으면
        if (segue.identifier == "segue_detail") {
            // 센더 인자를 캐스팅하여 테이블 셀 객체로 변환
            let cell = sender as! MovieCell
            
            // 세그웨이를 실행한 셀 객체 정보를 이용하여 몇 번째 행이 선택되었는지 확인한다
            let path = self.movieTable.indexPath(for: cell)
            
            // API 영화 데이터 배열 중에서 선택된 행에 대한 테이터를 얻는다
            let param = self.list[(path! as NSIndexPath).row]
            
            // 세그웨이가 향한 목적지 뷰 컨트롤러 객체를 읽어와 mvo 변수에 데이터를 연결해준다
            (segue.destination as? DetailViewController)?.mvo = param
        }
    }
    
}
