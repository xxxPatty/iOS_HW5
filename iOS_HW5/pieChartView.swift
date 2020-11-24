//
//  pieChartView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/22.
//

import SwiftUI

struct pieChart:Shape{
    var startangle:Angle
    var endangle:Angle
    
    func path(in rect: CGRect) -> Path {
        Path{(path) in
            let center=CGPoint(x:rect.midX, y:rect.midY)
            path.move(to: center)
            path.addArc(center:center, radius: rect.midX, startAngle: startangle, endAngle: endangle, clockwise: false)
        }
    }
}
struct pieChartView:View{
    var percentages:[Double]
    var angles:[Angle]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    init(percentages:[Double]){
        self.percentages=percentages
        angles=[Angle]()
        var startDegree:Double=0
        for percentage in percentages{
            angles.append(.degrees(startDegree))
            startDegree+=percentage*360/100
        }
    }
    var body: some View{
        ZStack{
            ForEach(angles.indices){(index) in
                if index==angles.count-1{
                    pieChart(startangle: angles[index], endangle: .zero)
                        .fill(pieChartColor[index])
                }else{
                    pieChart(startangle: angles[index], endangle: angles[index+1])
                        .fill(pieChartColor[index])
                }
            }
        }
    }
}
