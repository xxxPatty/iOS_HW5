//
//  chartview.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/22.
//

import SwiftUI


struct typeLabel:View{
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var body: some View{
        VStack(alignment:.leading){
            ForEach(someDramaTypes.indices){(index) in
                HStack{
                    Circle()
                        .fill(pieChartColor[index])
                        .frame(width:10, height:10)
                    Text("\(someDramaTypes[index])")
                }
            }
        }
    }
}

struct typeLabelWithPercentage:View{
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var percentages:[Double]
    var body: some View{
        VStack(alignment:.leading){
            ForEach(someDramaTypes.indices){(index) in
                HStack{
                    Circle()
                        .fill(pieChartColor[index])
                        .frame(width:10, height:10)
                    Text("\(someDramaTypes[index])")
                    Text("\(percentages[index], specifier: "%.2f")%")
                }
            }
        }
    }
}

struct chartView: View {
    @State private var chartType=0
    let someChartType=["圓餅圖", "長條圖", "甜甜圈"]
    @ObservedObject var dramaData=dramaInfoData()
    var dramaTypeNumPercentage:[Double]=[0, 0, 0, 0, 0, 0, 0, 0]
    var dramaTypeNum:[Double]=[0, 0, 0, 0, 0, 0, 0, 0]
    var completePercentage:Double=0
    var body: some View {
        VStack(alignment:.center){
            Picker(selection: $chartType, label: Text(""), content: {
                ForEach(someChartType.indices){(index) in
                    Text("\(someChartType[index])")
                }
            }).pickerStyle(SegmentedPickerStyle())
            .padding(20)
            
            if chartType==0{
                pieChartView(percentages:dramaTypeNumPercentage)
                    .frame(width:250, height:250)
                    .padding(.bottom, 50)
                typeLabelWithPercentage(percentages:dramaTypeNumPercentage)
                    .frame(height:200)
            }else if chartType==1{
                barGraphview(dramaTypeNum:dramaTypeNum, percentages:dramaTypeNumPercentage)
                    .frame(width:250, height:250)
                    .padding(.bottom, 50)
                typeLabel()
                    .frame(height:200)
            }else if chartType==2{
                donutChartView(percentages:completePercentage)
                    .frame(width:250, height:250)
                    .padding(.bottom, 50)
                VStack{
                    Text("已經追的劇")
                        .font(.largeTitle)
                    Text("\(completePercentage*100, specifier:"%.2f")%")
                }
                .frame(height:200)
            }
        }
    }
    //算各類型電影數量
    init(dramaData:dramaInfoData){
        self.dramaData=dramaData
        let total=dramaData.mydramaInfo.count
        completePercentage=0
        dramaTypeNum=[0, 0, 0, 0, 0, 0, 0, 0]
        for index in 0..<total{
            if dramaData.mydramaInfo[index].dramaType=="愛情"{
                dramaTypeNum[0]+=1
            }else if dramaData.mydramaInfo[index].dramaType=="冒險"{
                dramaTypeNum[1]+=1
            }else if dramaData.mydramaInfo[index].dramaType=="驚悚"{
                dramaTypeNum[2]+=1
            }else if dramaData.mydramaInfo[index].dramaType=="懸疑"{
                dramaTypeNum[3]+=1
            }else if dramaData.mydramaInfo[index].dramaType=="搞笑"{
                dramaTypeNum[4]+=1
            }else if dramaData.mydramaInfo[index].dramaType=="恐怖"{
                dramaTypeNum[5]+=1
            }else if dramaData.mydramaInfo[index].dramaType=="動作"{
                dramaTypeNum[6]+=1
            }else{
                dramaTypeNum[7]+=1
            }
        }
        for index in 0...7{
            if dramaTypeNum[index] == 0 {
                dramaTypeNumPercentage[index]=0
            }else{
                dramaTypeNumPercentage[index] = dramaTypeNum[index] / Double(total) * 100
            }
            
        }
        for index in 0..<total{
            if dramaData.mydramaInfo[index].done==true {
                completePercentage+=1
            }
        }
        if completePercentage != 0{
            completePercentage=completePercentage/Double(total)
        }
    }
}
