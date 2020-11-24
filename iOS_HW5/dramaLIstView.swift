//
//  dramaLIstView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/22.
//

import SwiftUI

struct dramaInfo:Identifiable, Codable{
    var id=UUID()
    var dramaName:String
    var dramaType:String
    var time:Date
    var actors:String
    var done:Bool=false
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
    @ObservedObject var dramaData=dramaInfoData()
    @State private var showDramaEditor=false
    @State private var searchText:String=""
    var filterWords: [dramaInfo] {
            return dramaData.mydramaInfo.filter({searchText.isEmpty ? true : $0.dramaName.contains(searchText)})
           }
    init(dramaData:dramaInfoData){
        self.dramaData=dramaData
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    var body: some View{
        NavigationView{
            VStack{
                SearchBar(text: $searchText)
                //.background(Color(red:231/255, green:216/255, blue:201/255))
                List{
                    ForEach(filterWords.indices){(index) in
                        NavigationLink(destination:dramaEditor(dramadata: dramaData, editDramaIndex:index)){
                            dramaRow(drama:dramaData.mydramaInfo[index])
                        }
                        .listRowBackground(Color(red:238/255, green:228/255, blue:225/255))
                    }
                    .onDelete{(indexSet) in
                        dramaData.mydramaInfo.remove(atOffsets: indexSet)
                    }
                    .onMove{(indexSet, index) in
                        dramaData.mydramaInfo.move(fromOffsets: indexSet, toOffset: index)
                    }
                }
                .background(Color(red:231/255, green:216/255, blue:201/255))
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("口袋名單")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action:{
                            showDramaEditor=true
                        }, label:{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color(red:230/255, green:190/255, blue:174/255))
                        })
                    }
                    ToolbarItem(placement:.navigationBarLeading){
                        EditButton()
                            .foregroundColor(Color(red:230/255, green:190/255, blue:174/255))
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
}

struct dramaLIstView_Previews: PreviewProvider {
    static var previews: some View {
        dramaList(dramaData:dramaInfoData())
    }
}
