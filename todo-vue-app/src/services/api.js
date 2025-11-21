import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json'
  }
});

// Add interceptor to include token in requests
apiClient.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default {
  setAuthToken(token) {
    if (token) {
      apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    } else {
      delete apiClient.defaults.headers.common['Authorization'];
    }
  },
  login(credentials) {
    return apiClient.post('/auth/login', credentials);
  },
  register(credentials) {
    return apiClient.post('/auth/register', credentials);
  },
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
