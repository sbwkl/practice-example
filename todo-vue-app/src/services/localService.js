const STORAGE_KEY = 'todo-app-todos';

const getLocalTodos = () => {
  const todos = localStorage.getItem(STORAGE_KEY);
  return todos ? JSON.parse(todos) : [];
};

const saveLocalTodos = (todos) => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
};

export default {
  // Auth methods (minimal implementation for local mode)
  setAuthToken(token) {
    console.log('Local mode: setAuthToken', token);
  },
  login(credentials) {
    console.log('Local mode: login', credentials);
    return Promise.resolve({ data: { token: 'local-token', username: credentials.username } });
  },
  register(credentials) {
    console.log('Local mode: register', credentials);
    return Promise.resolve({ data: { message: 'Registered locally' } });
  },

  // Todo methods
  getTodos() {
    const todos = getLocalTodos();
    return Promise.resolve({ data: todos });
  },
  getTodo(id) {
    const todos = getLocalTodos();
    const todo = todos.find(t => t.id === id);
    return todo 
      ? Promise.resolve({ data: todo })
      : Promise.reject(new Error('Todo not found'));
  },
  createTodo(todo) {
    const todos = getLocalTodos();
    const newTodo = {
      ...todo,
      id: Date.now().toString(), // Simple ID generation
      createdAt: new Date().toISOString()
    };
    todos.push(newTodo);
    saveLocalTodos(todos);
    return Promise.resolve({ data: newTodo });
  },
  updateTodo(id, todo) {
    const todos = getLocalTodos();
    const index = todos.findIndex(t => t.id === id);
    if (index !== -1) {
      todos[index] = { ...todos[index], ...todo };
      saveLocalTodos(todos);
      return Promise.resolve({ data: todos[index] });
    }
    return Promise.reject(new Error('Todo not found'));
  },
  deleteTodo(id) {
    let todos = getLocalTodos();
    todos = todos.filter(t => t.id !== id);
    saveLocalTodos(todos);
    return Promise.resolve({ data: { message: 'Deleted' } });
  }
};
