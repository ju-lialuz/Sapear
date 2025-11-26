//
//  SoundExerciseView.swift
//  Soundfy
//
//  Created by Pedro Pessuto on 29/09/23.
//

import SwiftUI
import AVFoundation

struct ExerciseView: View {
    
    @EnvironmentObject var profileController: ProfileController
    var exercise: Exercise
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var count: Int
    var changeScreen: () -> Void
    
    @State var exerciseAwnser: Int = -1
    @State var gotRight: Bool = false
    @State var selectedOption: Int = -1
    @State var waringText: String = ""
    @State var clickedAlternatives: [UUID] = []
    @State var selectedOptionId: UUID = UUID()
    @State var buttonDisabled: Bool = true
    @State var palavraescrita: String = "B"
    @State var isTalking: Bool = false
    @State var isFirst: Bool = true
    
    @State private var hasBeenRead = false
    
    @State private var showSheet: Bool = false
    
    
    @State var text: String = ""
    @State var subtitle: String = ""
    @State var buttonText: String = "Confirmar"
    @State var typeColor: String = "green"



    func playSound(Nome: String){
        let url = Bundle.main.url(forResource: Nome, withExtension: "mp3")
        guard url != nil else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        }catch{
            print("\(error)")
        }
    }
    
    func getSound() -> String {
        return exercise.exerciseAlternatives[exercise.exerciseAnswer].alternativeSoundName ?? ""
    }
    
    func handleNextScreen() {
        
        // Se já acertou prox tela
        if gotRight {
            changeScreen()
            buttonText = "Próximo"
            gotRight = false
            selectedOption = -1
            waringText = ""
            clickedAlternatives = []
            selectedOptionId = UUID()
            isFirst = true
            text = "Parabéns!"
            subtitle = "Resposta correta, você está se saindo bem!"
            typeColor = "green"
        }
        
        // Verifica se acertou
        if selectedOption == exerciseAwnser {
            
            gotRight = true
            text = "Parabéns!"
            subtitle = "Resposta correta, você está se saindo bem!"
            buttonText = "Próximo"
            typeColor = "green"
            
            if isFirst{
                if exercise.exerciseType == "soundExercise" {
                    profileController.soundsExercisesRight = profileController.soundsExercisesRight + 1
                    profileController.soundsExercisesDone = profileController.soundsExercisesDone + 1
                }
                else if exercise.exerciseType == "phonemeExercise" {
                    profileController.phonemeExercisesRight = profileController.phonemeExercisesRight + 1
                    profileController.phonemeExercisesDone = profileController.phonemeExercisesDone + 1
                }
                else if exercise.exerciseType == "wordExercise" {
                    profileController.wordsExercisesRight = profileController.wordsExercisesRight + 1
                    profileController.wordsExercisesDone = profileController.wordsExercisesDone + 1
                } else {
                    profileController.phrasesExercisesRight = profileController.phrasesExercisesRight + 1
                    profileController.phrasesExercisesDone = profileController.phrasesExercisesDone + 1
                }
            }
        }
        
        // Verifica se errou
        if selectedOption != exerciseAwnser && selectedOption != -1 {
            text = "Quase lá!"
            subtitle = "Não desanime, continue tentando!"
            buttonText = "Tente Novamente"
            typeColor = "red"
            
            if isFirst{
                if exercise.exerciseType == "soundExercise" {
                    profileController.soundsExercisesDone = profileController.soundsExercisesDone + 1
                }
                else if exercise.exerciseType == "phonemeExercise" {
                    profileController.phonemeExercisesDone = profileController.phonemeExercisesDone + 1
                }
                else if exercise.exerciseType == "wordExercise" {
                    profileController.wordsExercisesDone = profileController.wordsExercisesDone + 1
                } else {
                    profileController.phrasesExercisesDone = profileController.phrasesExercisesDone + 1
                }
            }
            
            isFirst = false
        }
        
        if !clickedAlternatives.contains(selectedOptionId) {
            clickedAlternatives.append(selectedOptionId)
        }
        
    }
    
    var body: some View {
        VStack {
            
            // ===== BODY =====
            VStack (spacing: 20) {
                Text(exercise.exerciseName)
                    .font(Font.custom("Quicksand-Bold", size: 38,relativeTo: .largeTitle))
                    .multilineTextAlignment(.center)
                    .bold()
                    .lineLimit(nil)
                
                Text(exercise.exerciseDescription)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                VStack {
                    if exercise.exerciseType == "soundExercise" {
                        SoundButton(buttonAction: {playSound(Nome: getSound())})
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text(hasBeenRead ? "" : "Áudio Botão"))
                    }
                    
                    else {
                        FrogTalking(exercise: exercise, playSound: playSound, getSound: getSound, palavraescrita: $palavraescrita, isDisabled: false, isTalking: $isTalking, type: exercise.exerciseType)
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text(hasBeenRead ? "" : "Sapo Botão"))
                    }
                }
                .onTapGesture {
                    hasBeenRead = true
                }
                
                if exercise.exerciseType != "phrasesExercise" {
                    LazyVGrid(columns: columns, spacing: 20) {
                        alternatives
                    }
                } else {
                    alternatives
                }
            }
            
            // ===== FOOTER =====
            Spacer()
            
            PlayButton(
                buttonAction: {
                    handleNextScreen()
                    playSound(Nome: "vazio")
                    showSheet = true
                },
                buttonText: buttonText,
                isDisabled: $buttonDisabled
            )
                .onChange(of: selectedOption) { newValue in
                    if selectedOption != -1 {
                        buttonDisabled = false
                    }
                    else {
                        buttonDisabled = true
                    }
                }
               
        }
        .sheet(isPresented: $showSheet) {
            PopoverMensagem(text: $text, subtitle: $subtitle, buttonText: $buttonText, typeColor: $typeColor, onNext: {
                handleNextScreen()
                playSound(Nome: "vazio")
                showSheet = false
            })
            .presentationDetents([.fraction(0.25)]) // opcional
            .presentationDragIndicator(.hidden)
        }
        .onAppear {
            
            exerciseAwnser = exercise.exerciseAnswer
        }
        .onChange(of: count, perform: { _ in
            let nextExercise: Exercise = profileController.actualPhase!.phaseExercises[count + 1]
            exerciseAwnser = nextExercise.exerciseAnswer
           
        })
        .padding(.horizontal, 30)
        .multilineTextAlignment(.center)
        .foregroundColor(Color(red: 56/255, green: 128/255, blue: 200/255))
    }
    
    @ViewBuilder
    var alternatives: some View {
        ForEach(exercise.exerciseAlternatives.indices, id: \.self) {
            number in
            ExerciseSoundButton(item: exercise.exerciseAlternatives[number], exercise: exercise, exerciseAnswer: exercise.exerciseAnswer, number: number, buttonAction: {
                if exercise.exerciseAlternatives[number].alternativeSoundName != nil {
                    playSound(Nome: exercise.exerciseAlternatives[number].alternativeSoundName ?? "")
                }
            }, selectedOption: $selectedOption, selectedOptionId: $selectedOptionId, clickedAlternatives: $clickedAlternatives)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Alternativa \(exercise.exerciseAlternatives[number].alternativeLabel) Botão"))
        }
    }
}


struct PopoverMensagem: View {
    @Binding var text: String
    @Binding var subtitle: String
    @Binding var buttonText: String
    @Binding var typeColor: String
    @State var buttonDisabled: Bool = false
    let onNext: () -> Void

    var body: some View {
        ZStack {
            if typeColor == "green" {
                Color(red: 236/255, green: 253/255, blue: 242/255).ignoresSafeArea()
            } else {
                Color(red: 255/255, green: 192/255, blue: 198/255).ignoresSafeArea()
            }
            VStack(spacing: 15) {
                HStack {
                    Text("\(text)")
                        .font(Font.custom("Quicksand-Bold", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(typeColor == "green" ? Color(red: 86/255, green: 189/255, blue: 55/255) : Color(red: 255/255, green: 45/255, blue: 45/255))
                    Spacer()
                        .padding(.bottom, 5)
                }
                
                HStack {
                    Text("\(subtitle)")
                        .font(Font.custom("Quicksand-Bold", size: 16))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(typeColor == "green" ? Color(red: 86/255, green: 189/255, blue: 55/255) : Color(red: 255/255, green: 45/255, blue: 45/255))
                    Spacer()
                }
                
                
                ExerciseButton(
                    buttonAction: {
                        onNext()
                    },
                    buttonText: buttonText,
                    typeColor: $typeColor,
                    isDisabled: $buttonDisabled
                )
            }
            .padding(.horizontal, 20)
        }
    }
}
