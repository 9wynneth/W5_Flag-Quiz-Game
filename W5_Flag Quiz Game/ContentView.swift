import SwiftUI

struct ContentView: View {
    let asean = ["Indonesia", "Singapore", "Malaysia", "Laos", "Philippines", "Cambodia", "Myanmar", "Thailand", "Brunei", "Vietnam"]
    @State private var angkaRandom = Int.random(in: 0...9)
    @State private var correct = 0
    @State private var wrong = 0
    @State private var roundsPlayed = 0
    @State public var isModal = false
    @State private var shownIndices: [Int] = []

    var body: some View {
        ZStack {
            Color.mint
                .ignoresSafeArea()

            VStack {
                Text("Pilih Bendera dari Negara : ")
                    .foregroundStyle(.black)
                Text(asean[angkaRandom])
                    .foregroundStyle(.black)
            }
        }

        HStack {
            Spacer()
            VStack {
                ForEach(0..<5) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(asean[number])
                            .resizable()
                            .frame(width: 105, height: 60)
                    }
                }
            }
            Spacer()
            VStack {
                ForEach(5..<10) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(asean[number])
                            .resizable()
                            .frame(width: 105, height: 60)
                    }
                }
            }
            Spacer()
        }

        .onChange(of: roundsPlayed) { newValue in
            if newValue >= 10 {
                isModal = true
                
            }
        }
        .sheet(isPresented: $isModal) {
            ResultView(correct: correct, wrong: wrong, resetGame: resetGame, isModal: $isModal)
        }
    }


    func flagTapped(_ number: Int) {
        if asean[number] == asean[angkaRandom] {
            correct += 1
        } else {
            wrong += 1
        }
        if roundsPlayed < 9 {
            shownIndices.append(angkaRandom)
            angkaRandom = generateUniqueRandomIndex()
        }
        roundsPlayed += 1
    }

    func generateUniqueRandomIndex() -> Int {
        var remainingIndices = Array(0..<asean.count).filter { !shownIndices.contains($0) }
            if remainingIndices.isEmpty {
                shownIndices.removeAll()
                remainingIndices = Array(0..<asean.count)
            }
            return remainingIndices.randomElement() ?? 0
    }

    func resetGame() {
        correct = 0
        wrong = 0
        roundsPlayed = 0
        shownIndices.removeAll()
        angkaRandom = generateUniqueRandomIndex()
    }
}

struct ResultView: View {
    var correct: Int
    var wrong: Int
    var resetGame: () -> Void
    @Binding var isModal: Bool
    @State private var alertShown = false

    var body: some View {
        VStack {
            Text("Correct: \(correct) / Wrong: \(wrong)")
                .padding()
            Button("OK") {
                resetGame()
                alertShown = true
            }   .alert("GAME ENDED", isPresented: $alertShown) {
                Button("RESTART", role: .cancel) {isModal = false}
            }
        message: {
            Text("Correct: \(correct) | Wrong: \(wrong)")
        }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
