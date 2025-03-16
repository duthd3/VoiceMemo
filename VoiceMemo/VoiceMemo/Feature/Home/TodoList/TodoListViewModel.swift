//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by jun on 5/1/24.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    // 편집모드인지 Todo 보여주는 모드인지
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool
    
    var removeTodosCount: Int {
        return removeTodos.count
    }
    // 네비게이션 바 오른쪽 버튼 모드(편집모드 or Todo 모드)
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditTodoMode ? .complete : .edit
    }
    
    init(todos: [Todo] = [], isEditModeTodoMode: Bool = false, removeTodos: [Todo] = [], isDisplayRemoveTodoAlert: Bool = false) {
        self.todos = todos
        self.isEditTodoMode = isEditModeTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

extension TodoListViewModel {
    // todo 박스가 탭 되었을때
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    // todo 항목 추가
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    // 네비게이션 상단 바 오른쪽 버튼 클릭
    func navigationRightBtnTapped() {
        if isEditTodoMode { // 편집모드 일 때
            if removeTodos.isEmpty { // 삭제할 게 없다면
                isEditTodoMode = false // 편집모드 그냥 false로
            } else { // 삭제할 게 있다면
                setIsDisplayRemoveTodoAlert(true) //삭제 alert 띄운다.(추후에 view에서 바인딩을 통해)
            }
        } else {
            isEditTodoMode = true
        }
    }
    // remove alert 띄울지 말지
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    // removeBox를 클릭했을 때
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    // alert에서 remove 버튼을 눌렀을 때
    func removeBtnTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        
        removeTodos.removeAll()
        // 삭제가 완료 되었으면
        isEditTodoMode = false
    }
}
