//
//  dramaEditorView.swift
//  iOS_HW5
//
//  Created by 林湘羚 on 2020/11/22.
//

import SwiftUI

struct dramaEditor:View{
    @State private var dramaName=""
    @State private var dramaType=""
    @State private var dramaTypeIndex=0
    @State private var time=Date()
    @State private var actors=""
    @State private var done=false
    @State private var reflections="影評"
    @State private var scores=6.0
    @Environment(\.presentationMode) var presentationMode
    var dramadata:dramaInfoData
    var editDramaIndex:Int?
    let someDramaTypes=["愛情", "冒險", "驚悚", "懸疑", "搞笑", "恐怖", "動作", "其他"]
    init(dramadata:dramaInfoData, editDramaIndex:Int?=nil){
        self.dramadata=dramadata
        self.editDramaIndex=editDramaIndex
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
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
                .toggleStyle(SwitchToggleStyle(tint: Color(red:230/255, green:190/255, blue:174/255)))
            TextEditor(text: $reflections)
                .disabled(!done)
                .frame(height:200)
            Stepper("分數\(scores, specifier:"%.1f")", value:$scores, in: 0...10, step:0.5)
                .disabled(!done)
        }
            .background(Color(red:231/255, green:216/255, blue:201/255))
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Add new drama")
            .toolbar(content: {
                ToolbarItem{
                    Button(action: {
                        if let editDramaIndex=editDramaIndex{
                            dramadata.mydramaInfo[editDramaIndex]=dramaInfo(dramaName: dramaName, dramaType: someDramaTypes[dramaTypeIndex], time: time, actors: actors, done: done, reflections: reflections, scores: scores)
                        }else{
                            dramadata.mydramaInfo.insert(dramaInfo(dramaName: dramaName, dramaType: someDramaTypes[dramaTypeIndex], time: time, actors: actors, done: done, reflections: reflections, scores: scores), at:0)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
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
                reflections=editDrama.reflections=="" ? "影評" : editDrama.reflections
                scores=editDrama.scores
                
                if dramaTypeIndex == 0 {
                    for i in 0...someDramaTypes.count-1{
                        if editDrama.dramaType==someDramaTypes[i]{
                            dramaTypeIndex=i
                        }
                    }
                }
            }
        })
        .navigationBarTitle(editDramaIndex == nil ? "Add new drama" : "Edit drama")
    }
}
