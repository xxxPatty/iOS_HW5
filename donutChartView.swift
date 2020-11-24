//
//  donutView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/22.
//

import SwiftUI

struct donut:View{
    @State private var trimEnd:Double=0
    var startpercentage:Double
    var endpercentage:Double
    var body: some View{
        Circle()
            .trim(from: CGFloat(startpercentage), to: CGFloat(trimEnd))
            .stroke(Color.pink, lineWidth: 30)
            .animation(.linear(duration: 2))
            .onAppear {
                trimEnd = endpercentage
            }
    }
}
struct donutChartView:View{
    var percentages:Double
    var body: some View{
        VStack{
            donut(startpercentage:0, endpercentage:percentages)
        }
    }
}
