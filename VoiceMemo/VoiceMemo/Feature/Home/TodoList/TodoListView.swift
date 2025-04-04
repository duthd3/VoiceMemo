//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by jun on 5/1/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        
        // todo cell List
        VStack(spacing: 0) {
            // todo가 1개도 없다면 navigation bar가 필요없음(편집 버튼이 필요없기 때문에)
            if !todoListViewModel.todos.isEmpty {
                CustomNavigationBar(
                    isDisplayLeftBtn: false,
                    rightBtnAction: {
                        todoListViewModel.navigationRightBtnTapped()
                    },
                    rightBtnType: todoListViewModel.navigationBarRightBtnMode
                )
            } else {
                Spacer()
                    .frame(height: 30)
            }
            
            TitleView()
                .padding(.top, 20)
            if todoListViewModel.todos.isEmpty {
                AnnouncementView()
            } else {
                TodoListContentView()
                    .padding(.top, 20)
            }
        }
        .modifier(WriteBtnViewModifier(action: { pathModel.paths.append(.todoView)}))
        .alert("To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?", isPresented: $todoListViewModel.isDisplayRemoveTodoAlert) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel) { }
        }
        .onChange(of: todoListViewModel.todos, perform: { todos in
            homeViewModel.setTodosCount(todos.count)
        })
    }
}

// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("Todo list를\n추가해주세요.")
            } else {
                Text("Todo list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
            
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList 안내뷰(TodoList가 없을 시)
private struct AnnouncementView: View {
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("\"매일 아침 8시 운동하자!\"")
            Text("\"내일 8시 수강 신청하자!\"")
            Text("\"1시 반 점심약속 리마인드 해보자!\"")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - TodoList 컨텐츠 뷰(todoList가 있을 때)
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle() // divider 용
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        // TODO: - Todo 셀 뷰 todo 넣어서 뷰 호출
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}

private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                if !todoListViewModel.isEditTodoMode {
                    Button(
                        action: { todoListViewModel.selectedBoxTapped(todo)}, label: {
                            todo.selected ? Image("selectedBox") : Image("unSelectedBox")}
                    )
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.selected ? .gray3 : .customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray3)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    } label: {
                        isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
        Rectangle()
            .fill(Color.customGray0)
            .frame(height: 1)
    }
}


// MARK: - Todo 작성 버튼 뷰
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Image("writeBtn")
                }
                
            }
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
}
