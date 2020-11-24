//
//  barGraphView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/22.
//

import SwiftUI

struct bar:View{
    @State private var barheight:Double=0
    var num:Double
    var body: some View{
        Rectangle()
            .frame(width:20, height:CGFloat(barheight))
            .animation(.linear(duration: 2))
            .onAppear {
                barheight = num
            }
    }
}
struct barGraphview:View{
    var dramaTypeNum:[Double]
    var percentages:[Double]
    let ChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    var body: some View{
        VStack{
            HStack(alignment:.bottom){
                ForEach(0..<dramaTypeNum.count){(index) in
                    VStack{
                        bar(num:percentages[index])
                                            .foregroundColor(ChartColor[index])
                        Text("\(dramaTypeNum[index], specifier:"%.0f")")
                    }
                    
                }
                .padding(.trailing, 10)
            }
        }
    }
}
