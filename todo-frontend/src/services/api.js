import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json'
  }
});

export default {
  getTodos() {
    return apiClient.get('/todos');
  },
  getTodo(id) {
    return apiClient.get(`/todos/${id}`);
  },
  createTodo(todo) {
    return apiClient.post('/todos', todo);
  },
  updateTodo(id, todo) {
    return apiClient.put(`/todos/${id}`, todo);
  },
  deleteTodo(id) {
    return apiClient.delete(`/todos/${id}`);
  }
};
