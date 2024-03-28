//
//  SelectQuestionView.swift
//  ABloom
//
//

import SwiftUI

struct SelectQuestionView: View {
  let isLoggedIn: Bool
  
  @StateObject var selectQVM = SelectQuestionViewModel()
  @StateObject var activeSheet: ActiveSheet
  @Environment(\.dismiss) private var dismiss
  @Binding var isSheetOn: Bool
  
  var selectedCategory: Category
  
  var body: some View {
    VStack(spacing: 0) {
      
      categoryBar
      bottomGradient
      
      if isLoggedIn {
        questionListView
      } else {
        previewStaticQuesiton
      }
    }
    .customNavigationBar {
      EmptyView()
    } leftView: {
      Button(action: {dismiss()
      }, label: {
        NavigationArrowLeft()
      })
    } rightView: {
      EmptyView()
    }
    .ignoresSafeArea(.all, edges: .bottom)
    
    .onAppear {
      if selectQVM.isQuestionLabBtnActive {
        selectQVM.isQuestionLabBtnActive = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
          withAnimation(.easeIn(duration: 0.3)) {
            selectQVM.isQuestionLabBtnActive = true
          }
        }
      }
      
      if !selectQVM.didGetCategory {
        selectQVM.updateSelectedCategory(new: selectedCategory)
      }
    }
    
    .navigationDestination(isPresented: $selectQVM.isAnswerSheetOn, destination: {
      if let selectedQ = selectQVM.selectedQuestion {
        WriteAnswerView(isSheetOn: $isSheetOn, question: selectedQ)
      }
    })
  }
}

extension SelectQuestionView {
  
  private var categoryBar: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        
        HStack(spacing: 30) {
          
          ForEach(Category.allCases, id: \.self) { category in
            
            VStack(alignment: .center, spacing: 0) {
              
              Image(category.rawValue)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .padding(.bottom, 6)
              
              Text(category.type)
                .customFont(.caption2B)
                .padding(.bottom, 11)
              
              Divider()
                .frame(width: 30, height: 2)
                .overlay(.primary70)
                .opacity(selectQVM.selectedCategory == category ? 1 : 0)
            }
            .padding(.horizontal, 10)
            .tag(category)
            .foregroundStyle(selectQVM.selectedCategory == category ? .primary70 : .gray400)
            .opacity(selectQVM.selectedCategory == category ? 1 : 0.4)
            .onTapGesture(perform: {
              selectQVM.selectCategory(seleted: category)
            })
          }
        }
        .padding(.top, 32)
        .padding(.horizontal, 20)
      }
      .onChange(of: selectQVM.selectedCategory) { new in
        proxy.scrollTo(selectQVM.selectedCategory)
      }
    }
  }
  
  private var bottomGradient: some View {
    Rectangle()
      .fill(LinearGradient(
        colors: [.topBlur, .clear],
        startPoint: .top, endPoint: .bottom)
      )
      .frame(maxWidth: .infinity)
      .frame(height: 5)
  }
  
  private func questionItem(selectedQ: DBStaticQuestion) -> some View {
    VStack {
      Text(selectedQ.content.containsNumbers() ? selectedQ.content : selectedQ.content.useNonBreakingSpace())
        .customFont(.subHeadlineR)
        .foregroundStyle(.gray500)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
      
      Divider()
        .frame(maxWidth: .infinity)
        .frame(height: 1)
        .overlay(.gray100)
    }
    .onTapGesture {
      selectQVM.questionClicked(selectedQ: selectedQ)
      MixpanelManager.qnaSelectQuestion(questionId: selectedQ.questionID)
    }
  }
  
  private var questionListView: some View {
    ScrollViewReader { proxy in
      ScrollView(.vertical) {
        Spacer()
          .frame(height: 4)
          .id("top")
        
        ForEach(selectQVM.filteredLists, id: \.self) { question in
          questionItem(selectedQ: question)
        }
        Spacer()
          .frame(height: 50)
      }
      
      .onChange(of: selectQVM.selectedCategory) { new in
        proxy.scrollTo("top")
      }
    }
    .frame(maxWidth: .infinity)
    .overlay(alignment: .bottom) {
      questionLabButton
    }
  }
  
  private var questionLabButton: some View {
    NavigationLink {
      EmbedWebView(viewTitle: "질문 제작소", urlString: ServiceWebURL.questionLab.rawValue, type: .navigation, showSheet: .constant(true), checkContract: .constant(true))
    } label: {
      VStack(alignment: .leading, spacing: 12) {
        Text("마음에 드는 질문을 찾지 못하셨나요?")
          .customFont(.caption1R)
        HStack(spacing: 13) {
          Text("메리 질문 제작소에서 직접 질문 만들기")
            .customFont(.calloutB)
          Image("chevron.right")
        }
      }
      .padding(.vertical, 24)
      .padding(.leading, 32)
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(.white)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .foregroundStyle(.primary80)
      )
    }
    .padding(.horizontal, 24)
    .overlay(alignment: .topTrailing) {
      Button {
        selectQVM.isQuestionLabBtnActive.toggle()
      } label: {
        Circle()
          .foregroundStyle(.primary80)
          .frame(width: 32, height: 32)
          .overlay {
            Image("xmark")
              .resizable()
              .renderingMode(.template)
              .frame(width: 14, height: 14)
              .foregroundStyle(.white)
          }
          .background(
            Circle().stroke(style: StrokeStyle(lineWidth: 2))
              .foregroundStyle(.white)
          )
      }
      .padding(.trailing, 16)
      .padding(.top, -8)
    }
    .opacity(selectQVM.isQuestionLabBtnActive ? 1 : 0)
    .padding(.bottom, 52)
  }
  
  private var previewStaticQuesiton: some View {
    
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {
        Image(selectQVM.selectedCategory.staticImg)
          .resizable()
          .scaledToFill()
          .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
          .clipped()
        
        VStack {
          Text("지금 로그인하면 메리의 200개가 넘는\n모든 질문들을 확인할 수 있어요!")
            .customFont(.footnoteB)
            .foregroundStyle(.gray50)
            .multilineTextAlignment(.center)
            .padding(.bottom, 15)
          
          Button {
            isSheetOn.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              activeSheet.kind = .signIn
            }
            MixpanelManager.signInTry(loginPoint: "categoryN")
          } label: {
            Text("로그인하기 >")
              .padding(.bottom, 3)
              .underline(true)
              .customFont(.calloutB)
              .foregroundStyle(.white)
              .padding(.bottom, 66)
          }
        }
        .padding(.horizontal, 20)
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
  SelectQuestionView(isLoggedIn: true, selectQVM: SelectQuestionViewModel(), activeSheet: ActiveSheet(), isSheetOn: .constant(true), selectedCategory: .child)
}
