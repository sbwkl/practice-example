import api from './api';
import localService from './localService';

const STORAGE_MODE_KEY = 'todo-app-storage-mode';

export const MODES = {
  REMOTE: 'remote',
  LOCAL: 'local'
};

class TodoService {
  constructor() {
    this.currentMode = localStorage.getItem(STORAGE_MODE_KEY) || MODES.REMOTE;
  }

  setMode(mode) {
    if (Object.values(MODES).includes(mode)) {
      this.currentMode = mode;
      localStorage.setItem(STORAGE_MODE_KEY, mode);
      window.location.reload(); // Reload to apply changes across the app
    }
  }

  getService() {
    return this.currentMode === MODES.REMOTE ? api : localService;
  }

  async checkApiAvailability() {
    try {
      // Try to fetch todos to check availability
      await api.getTodos();
      return true;
    } catch (error) {
      console.warn('API is unavailable, consider switching to local mode.');
      return false;
    }
  }

  // Proxy all methods
  setAuthToken(token) {
    return this.getService().setAuthToken(token);
  }

  login(credentials) {
    return this.getService().login(credentials);
  }

  register(credentials) {
    return this.getService().register(credentials);
  }

  getTodos() {
    return this.getService().getTodos();
  }

  getTodo(id) {
    return this.getService().getTodo(id);
  }

  createTodo(todo) {
    return this.getService().createTodo(todo);
  }

  updateTodo(id, todo) {
    return this.getService().updateTodo(id, todo);
  }

  deleteTodo(id) {
    return this.getService().deleteTodo(id);
  }
}

export default new TodoService();
