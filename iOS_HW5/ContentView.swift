//
//  ContentView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/15.
//

import SwiftUI
struct dramaInfo:Identifiable, Codable{
    var id=UUID()
    var dramaName:String
    var dramaType:String
    var time:Date
    var actors:String
    var done:Bool
    var reflections:String
    var scores:Double
}
class dramaInfoData:ObservableObject{
    @AppStorage("dramaInfo") var dramaInfoData:Data?
    @Published var mydramaInfo=[dramaInfo](){
        didSet{ //property observer
            let encoder=JSONEncoder()
            do{
                let data=try encoder.encode(mydramaInfo)
                dramaInfoData=data
            }catch{
                
            }
        }
    }
    init(){
        if let dramaInfoData=dramaInfoData{
            let decoder=JSONDecoder()
            if let decodedData=try? decoder.decode([dramaInfo].self, from: dramaInfoData){
                mydramaInfo=decodedData
            }
        }
    }
}
struct dramaRow:View{
    var drama:dramaInfo
    var body: some View{
        HStack{
            Text(drama.dramaName)
            Spacer()
            Text((drama.scores>8) ? "推" : "不推")
            Image(systemName: (drama.scores>8) ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
        }
    }
}
struct dramaList:View{
    @StateObject var dramaData=dramaInfoData()
    @State private var showDramaEditor=false
    var body: some View{
        NavigationView{
            List{
                ForEach(dramaData.mydramaInfo.indices, id:\.self){(index) in
                    NavigationLink(destination:dramaEditor(dramadata: dramaData, editDramaIndex:index)){
                        dramaRow(drama:dramaData.mydramaInfo[index])
                    }
                }
                .onDelete{(indexSet) in
                    dramaData.mydramaInfo.remove(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("口袋名單")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action:{
                        showDramaEditor=true
                    }, label:{
                        Image(systemName: "plus.circle.fill")
                    })
                }
                ToolbarItem(placement:.navigationBarLeading){
                    EditButton()
                }
            })
            .sheet(isPresented: $showDramaEditor){
                NavigationView{
                    dramaEditor(dramadata:dramaData)
                }
            }
        }
    }
}
struct dramaEditor:View{
    @State private var dramaName=""
    @State private var dramaType=""
    @State private var dramaTypeIndex=0
    @State private var time=Date()
    @State private var actors=""
    @State private var done=false
    @State private var reflections=""
    @State private var scores=6.0
    @Environment(\.presentationMode) var presentationMode
    var dramadata:dramaInfoData
    var editDramaIndex:Int?
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    var body: some View{
        Form{
            TextField("劇名", text:$dramaName)
            Picker(selection: $dramaTypeIndex, label: Text("類型"), content: {
                ForEach(someDramaTypes.indices){(index) in
                    Text("\(someDramaTypes[index])")
                }
            })
            DatePicker("上映日", selection: $time, displayedComponents:.date)
            TextField("演員", text:$actors)
            Toggle("已追", isOn: $done)
            TextField("影評", text:$reflections)
            Stepper("分數\(scores, specifier:"%.1f")", value:$scores, in: 0...10, step:0.5)
        }
            .navigationBarTitle("Add new drama")
            .toolbar(content: {
                ToolbarItem{
                
                Button("Save"){
                    if let editDramaIndex=editDramaIndex{
                        dramadata.mydramaInfo[editDramaIndex]=dramaInfo(dramaName: dramaName, dramaType: someDramaTypes[dramaTypeIndex], time: time, actors: actors, done: done, reflections: reflections, scores: scores)
                    }else{
                        dramadata.mydramaInfo.insert(dramaInfo(dramaName: dramaName, dramaType: someDramaTypes[dramaTypeIndex], time: time, actors: actors, done: done, reflections: reflections, scores: scores), at:0)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                }
            })
        
        .onAppear(perform:{
            if let editDramaIndex=editDramaIndex{
                let editDrama=dramadata.mydramaInfo[editDramaIndex]
                dramaName=editDrama.dramaName
                dramaType=editDrama.dramaType
                time=editDrama.time
                actors=editDrama.actors
                done=editDrama.done
                reflections=editDrama.reflections
                scores=editDrama.scores
                for i in 0...someDramaTypes.count-1{
                    if editDrama.dramaType==someDramaTypes[i]{
                        dramaTypeIndex=i
                    }
                }
            }
        })
        .navigationBarTitle(editDramaIndex == nil ? "Add new drama" : "Edit drama")
    }
}
//算各類型電影數量
func countType(dramaData:dramaInfoData)->[Double]{
    var dramaTypeNum:[Double]=[0, 0, 0, 0, 0, 0, 0, 0]
    let total=dramaData.mydramaInfo.count
    for index in 0...total-1{
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
        dramaTypeNum[index] = dramaTypeNum[index] / Double(total) * 100
    }
    return dramaTypeNum
}
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
struct bar:View{
    var num:Double
    var body: some View{
        Rectangle()
            .frame(width:20, height:CGFloat(num))
    }
}
struct barGraphview:View{
    var dramaTypeNum:[Double]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var body: some View{
        HStack(alignment:.bottom){
            ForEach(dramaTypeNum.indices){(index) in
                bar(num:dramaTypeNum[index])
                    .foregroundColor(pieChartColor[index])
                    .padding(10)
            }
        }
    }
}
struct donut:View{
    var startpercentage:Double
    var endpercentage:Double
    var body: some View{
        Circle()
            .trim(from: CGFloat(startpercentage), to: CGFloat(endpercentage))
            .stroke(Color.red, lineWidth: 30)
    }
}
struct donutChartView:View{
    var percentages:[Double]
    var donutpercentages:[Double]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    init(percentages:[Double]){
        self.percentages=percentages
        donutpercentages=[Double]()
        var start:Double=0
        for percentage in percentages{
            donutpercentages.append(start/100)
            start+=percentage
        }
    }
    var body: some View{
        ZStack {
            ForEach(donutpercentages.indices){(index) in
                if index==donutpercentages.count-1{
                    Circle()
                        .trim(from: CGFloat(donutpercentages[index]), to: 1)
                        .stroke(pieChartColor[index], lineWidth: 30)
                }else{
                    Circle()
                        .trim(from: CGFloat(donutpercentages[index]), to: CGFloat(donutpercentages[index+1]))
                        .stroke(pieChartColor[index], lineWidth: 30)
                }
            }
        }
    }
}
struct typeLabel:View{
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var body: some View{
        VStack{
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
struct chartView: View {
    @State private var chartType=0
    let someChartType=["圓餅圖", "長條圖", "甜甜圈"]
    @StateObject var dramaData=dramaInfoData()
    //@State private var result=[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    //@StateObject var dramaTypeNum=result()
    var body: some View {
        VStack{
            Picker(selection: $chartType, label: Text(""), content: {
                ForEach(someChartType.indices){(index) in
                    Text("\(someChartType[index])")
                }
            }).pickerStyle(SegmentedPickerStyle())
            .padding(20)
            
            //算各類型電影數量
            //result=countType(dramaData:dramaData)
            if chartType==0{
                pieChartView(percentages:countType(dramaData:dramaData))
                    .frame(width:250, height:250)
            }else if chartType==1{
                barGraphview(dramaTypeNum:countType(dramaData:dramaData))
                    .frame(width:250, height:250)
            }else if chartType==2{
                donutChartView(percentages:countType(dramaData:dramaData))
                    .frame(width:250, height:250)
            }
            typeLabel()
                .position(x:50, y:UIScreen.main.bounds.height-700)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView{
            dramaList()
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text("List")
                }
            chartView()
                .tabItem{
                    Image(systemName: "chart.pie.fill")
                    Text("chart")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
