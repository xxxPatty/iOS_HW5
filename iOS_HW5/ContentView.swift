//
//  ContentView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/15.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dramaData=dramaInfoData()
    var body: some View {
        TabView{
            dramaList(dramaData:dramaData)
                .tabItem{
                    Image(systemName: "list.bullet")
                        .foregroundColor(Color(red:230/255, green:190/255, blue:174/255))
                    Text("List")
                        .foregroundColor(Color(red:230/255, green:190/255, blue:174/255))
                }
            VStack{
                Text("統計圖表")
                    .font(.largeTitle)
                chartView(dramaData:dramaData)
            }
                .frame(width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
                .background(Color(red:231/255, green:216/255, blue:201/255))
                .edgesIgnoringSafeArea(.all)
                .tabItem{
                    Image(systemName: "chart.pie.fill")
                    Text("chart")
                }
        }
        .accentColor(Color(red:127/255, green:85/255, blue:57/255))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
