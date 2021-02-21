//
//  ContentView.swift
//  WeatherDataTest
//
//  Created by pakkun on 2021/02/21.
//

import SwiftUI

struct ContentView: View {
  @State var tempData: String = ""
  
  var body: some View {
    VStack {
      Button("start", action: start)
      TextEditor(text: $tempData)
    }
  }
  
  func start() {
    let url = URL(string: "https://www.data.jma.go.jp/obd/stats/data/mdrr/tem_rct/alltable/mxtemsadext00_rct.csv")!
    let downloadTask = URLSession.shared.downloadTask(with: url) {urlOrNil, responseOrNil, errorOrNil in
      guard let fileURL = urlOrNil else { return }
      do {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let savedURL = documentsURL?.appendingPathComponent(fileURL.lastPathComponent)
        try FileManager.default.moveItem(at: fileURL, to: savedURL!)
        let csvString = try String(contentsOf: savedURL!, encoding: String.Encoding.shiftJIS)
        let csvLines = csvString.components(separatedBy: .newlines)
        let dateTime = csvLines[2].components(separatedBy: ",")
        tempData = "\(dateTime[4])/\(dateTime[5])/\(dateTime[6]) 広島県 最高気温\n\n"
        for element in csvLines {
          if element == "" { continue }
          let data = element.components(separatedBy: ",")
          if data[1] == "広島県" {
            tempData += "\(data[2]): \(data[9]) ℃\n"
          }
        }
      } catch {
      }
    }
    downloadTask.resume()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
