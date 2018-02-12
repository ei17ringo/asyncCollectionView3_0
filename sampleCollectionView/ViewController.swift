//
//  ViewController.swift
//  sampleCollectionView
//
//  Created by Eriko Ichinohe on 2016/02/11.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate  {

    let queue:DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)

    var musicList:[NSDictionary] = []

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.isHidden = true
        indicator.startAnimating()
        queue.async {() -> Void in
            // 別スレッドでの処理
            //itunesのAPIからtaylor swiftの情報を20件取得
            var url = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=taylor+swift&limit=20")
            var request = URLRequest(url:url!)
            var jsondata = (try! NSURLConnection.sendSynchronousRequest(request, returning: nil))
            let jsonDictionary = (try! JSONSerialization.jsonObject(with: jsondata, options: [])) as! NSDictionary
            
            //APIから取得してきたデータの中で使用するものだけを、newMusicに保存
            
            for(key, data) in jsonDictionary{
                //print("\(key)=\(data)")
                if (key as! String == "results"){
                    var resultArray = data as! NSArray
                    for (eachMusic) in resultArray{
                        var eachMusicDic:NSDictionary = eachMusic as! NSDictionary
                        
                        print(eachMusicDic["artworkUrl100"])
                        print(eachMusicDic["trackName"])
                        var newMusic:NSDictionary = ["name":eachMusicDic["trackName"] as! String,"image":eachMusicDic["artworkUrl100"] as! String]
                        
                        //配列のプロパティに追加
                        self.musicList.append(newMusic)
                        
                    }
                    
                }
            }
            
            self.myCollectionView.reloadData()
            self.myCollectionView.isHidden = false
            
            self.indicator.stopAnimating()
        }


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
//        cell.title.text = "タイトル";
//        cell.image.image = UIImage(named: "berry.png")
        
        // URLを元に画像データを取得
        let url = URL(string: musicList[indexPath.row]["image"] as! String);
        var err: NSError?;
        let imageData :Data = (try! Data(contentsOf: url!,options: NSData.ReadingOptions.mappedIfSafe));
        let img = UIImage(data:imageData);
        
        cell.title.text = musicList[indexPath.row]["name"] as! String;
        cell.image.image = img
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicList.count;
    }

}

