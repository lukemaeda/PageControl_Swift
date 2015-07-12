//
//  ViewController.swift
//  PageControl_Swift
//
//  Created by MAEDAHAJIME on 2015/07/12.
//  Copyright (c) 2015年 MAEDA HAJIME. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIScrollViewDelegate{
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // スクロール＆ズームとスクロールビューに追加したい画像を設定
        pageImages = [UIImage(named:"img01.png")!,
            UIImage(named:"img02.png")!,
            UIImage(named:"img03.png")!,
            UIImage(named:"img04.png")!]
        
        // ページカウント
        let pageCount = pageImages.count
        
        // ページの設定
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 各ページのビューを保持するための配列を設定
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // スクロールビューのコンテンツサイズを設定
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        // 画面上にあるページの初期セットをロード
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // ページが範囲外の場合は、表示はしない
            return
        }
        
        // ロードしたページのチェック
        if let pageView = pageViews[page] {
            // ビューがロードされているので何もしない
        } else {
            // X座標 Y座標の位置
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // Newページをスクロールに追加
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    // パージページの設定
    func purgePage(page: Int) {
        
        // ページ範囲外の判定
        if page < 0 || page >= pageImages.count {
            // 表示範囲外の場合は、何もしない
            return
        }
        
        // スクロールビューからページを削除し、コンテナの配列をリセット
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    // ページの初期セット
    func loadVisiblePages() {
        
        // 表示ページ
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // ページコントロールの更新
        pageControl.currentPage = page
        
        // 最初と最後のページ加算減算
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // 最初のページの前にパージをセット
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // ページの範囲
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // 最後のページの後にパージをセット
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 画面上にページをロード
        loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

