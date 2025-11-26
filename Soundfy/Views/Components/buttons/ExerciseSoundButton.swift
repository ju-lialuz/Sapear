//
//  SoundAlternativeButton.swift
//  Soundfy
//
//  Created by Pedro Pessuto on 02/10/23.
//

import SwiftUI

struct ExerciseSoundButton: View {
    var item: Alternative
    var exercise: Exercise
    var exerciseAnswer: Int
    var number: Int
    var buttonAction: () -> Void
    @State var isWrong: Bool = false
    @State var isRight: Bool = false
    @Binding var selectedOption: Int
    @Binding var selectedOptionId: UUID
    @Binding var clickedAlternatives: [UUID]
    
    @State var buttonPrimaryColor: Color = Color(red: 242/255, green: 165/255, blue: 132/255)
    @State var buttonSecondaryColor: Color = Color(red: 238/255, green: 128/255, blue: 81/255)
    @State var buttonPading: CGFloat = 8
    
    func getSafeImage(named: String) -> Bool {
        
        let uiImage =  (UIImage(named: named) ?? UIImage(named: "Default.png"))!
        if uiImage == UIImage(named: "Default.png"){
            return false
        }
        return true
    }
    
    var body: some View {
        
        VStack {
            
            if isWrong {
                VStack {
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 83/255, green: 83/255, blue: 83/255))
                            .frame(width: exercise.exerciseType == "phrasesExercise" ? 328 : 157, height: exercise.exerciseType == "phrasesExercise" ? 63 : 105)

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 255/255, green: 45/255, blue: 45/255))
                                .frame(width: exercise.exerciseType == "phrasesExercise" ? 328 : 157, height: exercise.exerciseType == "phrasesExercise" ? 63 : 105)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 191/255, green: 34/255, blue: 34/255), lineWidth: 3)
                                )
                            
                            
                            VStack {
                                if  item.alternativeImage != "" {
                                    if getSafeImage(named: item.alternativeImage!) {
                                        Image(item.alternativeImage!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundStyle(Color.white)
                                    }
                                    else {
                                        Image(systemName: item.alternativeImage!)
                                            .font(.system(size: 48))
                                            .foregroundStyle(Color.white)
                                    }
                                }
                                if (exercise.exerciseType == "phonemeExercise") {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                    .font(Font.custom("Quicksand-Bold", size: 68, relativeTo: .largeTitle))
                                } else if (exercise.exerciseType == "wordExercise") {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                                } else if (exercise.exerciseType == "soundExercise") {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                                } else {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                                }                            }
                            .foregroundColor(.secondary)
                        }
                        .padding(.trailing, buttonPading)
                        .padding(.bottom, buttonPading)
                        
                        
                        // mudar alternativa
                        ZStack{
                            Image("wrong")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.white)
//                                .fontWeight(.black)
                            
//                            Image(systemName: "xmark")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 45, height: 45)
//                                .foregroundColor(.red)
//                                .bold()
                        }.offset(x: exercise.exerciseType == "phrasesExercise" ? 150 : 60, y: exercise.exerciseType == "phrasesExercise" ? -20 : -40)
                        
                        
                    }
                }
            }
            else if isRight {
                VStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 34/255, green: 169/255, blue: 1/255))
                            .frame(width: exercise.exerciseType == "phrasesExercise" ? 328 : 157, height: exercise.exerciseType == "phrasesExercise" ? 63 : 105)

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 86/255, green: 189/255, blue: 55/255))
                                .frame(width: exercise.exerciseType == "phrasesExercise" ? 328 : 157, height: exercise.exerciseType == "phrasesExercise" ? 63 : 105)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 54/255, green: 124/255, blue: 39/255), lineWidth: 3)
                                )
                            
                            
                            VStack {
                                if item.alternativeImage != "" {
                                    
                                    if getSafeImage(named: item.alternativeImage!) {
                                        
                                        Image(item.alternativeImage!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundStyle(Color.white)
                                    }
                                    else {
                                        Image(systemName: item.alternativeImage!)
                                            .font(.system(size: 48))
                                            .foregroundStyle(Color.white)
                                    }
                                }
                                if (exercise.exerciseType == "phonemeExercise") {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 68, relativeTo: .largeTitle))
                                } else if (exercise.exerciseType == "wordExercise") {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                                } else if (exercise.exerciseType == "soundExercise") {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                                } else {
                                    Text(item.alternativeLabel)
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                                }
                            }
                            .foregroundColor(.green)
                        }
                        .padding(.trailing, buttonPading)
                        .padding(.bottom, buttonPading)
                        
                        ZStack{
                            Image("right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.white)
//                                .fontWeight(.black)
                            
//                            Image(systemName: "checkmark")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 45, height: 45)
//                                .foregroundColor(.green)
//                                .bold()
                        }.offset(x: exercise.exerciseType == "phrasesExercise" ? 150 : 60, y: exercise.exerciseType == "phrasesExercise" ? -20 : -40)
                        
                        
                    }
                }
            }
            else {
                VStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(buttonSecondaryColor)
                            .frame(width: exercise.exerciseType == "phrasesExercise" ? 328 : 157, height: exercise.exerciseType == "phrasesExercise" ? 63 : 105)

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(buttonPrimaryColor)
                                .frame(width: exercise.exerciseType == "phrasesExercise" ? 328 : 157, height: exercise.exerciseType == "phrasesExercise" ? 63 : 105)

                            
                            VStack {
                                if item.alternativeImage != "" {
                                    if getSafeImage(named: item.alternativeImage!) {
                                        Image(item.alternativeImage!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                    else {
                                        Image(systemName: item.alternativeImage!)
                                            .font(.system(size: 48))
                                    }
                                }
                                if (exercise.exerciseType == "phonemeExercise") {
                                    Text(item.alternativeLabel)
                                    .font(Font.custom("Quicksand-Bold", size: 68, relativeTo: .largeTitle))
                                } else if (exercise.exerciseType == "wordExercise") {
                                    Text(item.alternativeLabel)
                                        .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                                } else if (exercise.exerciseType == "soundExercise") {
                                    Text(item.alternativeLabel)
                                        .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                                } else {
                                    Text(item.alternativeLabel)
                                        .font(Font.custom("Quicksand-Bold", size: 20, relativeTo: .largeTitle))
                                }                            }
                            .foregroundColor(.white)
                        }
                        .padding(.trailing, buttonPading)
                        .padding(.bottom, buttonPading)
                    }
                }
            }
        }
        .onTapGesture {
            selectedOption = number
            selectedOptionId = item.alternativeId
            buttonAction()
        }
        .onChange(of: clickedAlternatives, perform: { newValue in
            
            if clickedAlternatives.contains(item.alternativeId) {
                if exerciseAnswer == number {
                    isRight = true
                }
                else {
                    isWrong = true
                }
            }
            
            else {
                isWrong = false
                isRight = false
            }
            
        })
        .onChange(of: selectedOption) { newValue in
            
            if selectedOption == number {
                buttonPrimaryColor = Color(red: 238/255, green: 128/255, blue: 81/255)
                buttonPading = 0
            }
            else {
                buttonPrimaryColor =  Color(red: 242/255, green: 165/255, blue: 132/255)
                buttonPading = 8
            }
        }
        
    }
}
