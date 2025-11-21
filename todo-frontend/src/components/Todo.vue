<template>
  <div>
    <h1>Todo List</h1>
    <input v-model="newTodo.title" @keyup.enter="addTodo" placeholder="Add a new todo" />
    <ul>
      <li v-for="todo in todos" :key="todo.id">
        <span v-if="!todo.editing">{{ todo.title }}</span>
        <input v-else v-model="todo.title" @keyup.enter="updateTodo(todo)" @blur="updateTodo(todo)" />
        <div class="buttons">
          <button class="edit-btn" @click="toggleEdit(todo)">{{ todo.editing ? 'Cancel' : 'Edit' }}</button>
          <button class="delete-btn" @click="deleteTodo(todo.id)">Delete</button>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import api from '../services/api';

export default {
  data() {
    return {
      todos: [],
      newTodo: {
        title: ''
      }
    };
  },
  created() {
    this.fetchTodos();
  },
  methods: {
    async fetchTodos() {
      try {
        const response = await api.getTodos();
        this.todos = response.data.map(todo => ({ ...todo, editing: false }));
      } catch (error) {
        console.error('Error fetching todos:', error);
      }
    },
    async addTodo() {
      if (this.newTodo.title.trim() !== '') {
        try {
          const newTodoData = {
              title: this.newTodo.title,
              description: " ",
              status: 'TODO',
              priority: 'MEDIUM',
          };
          const response = await api.createTodo(newTodoData);
          this.todos.push({ ...response.data, editing: false });
          this.newTodo.title = '';
        } catch (error) {
          console.error('Error adding todo:', error);
        }
      }
    },
    toggleEdit(todo) {
      todo.editing = !todo.editing;
    },
    async updateTodo(todo) {
      if (!todo.editing) return;
      todo.editing = false;
      try {
        await api.updateTodo(todo.id, { title: todo.title, description: todo.description, status: todo.status, priority: todo.priority });
      } catch (error) {
        console.error('Error updating todo:', error);
        // Optionally revert the change in the UI
        this.fetchTodos();
      }
    },
    async deleteTodo(id) {
      try {
        await api.deleteTodo(id);
        this.todos = this.todos.filter(todo => todo.id !== id);
      } catch (error) {
        console.error('Error deleting todo:', error);
      }
    }
  }
};
</script>

<style scoped>
div {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  text-align: left;
}

h1 {
  text-align: center;
  color: #2c3e50;
}

input {
  width: calc(100% - 40px);
  padding: 10px;
  margin-bottom: 20px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

span {
  cursor: pointer;
}

.buttons {
  display: flex;
  gap: 10px;
}

button {
  padding: 5px 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  color: white;
}

.edit-btn {
  background-color: #42b983;
}

.delete-btn {
  background-color: #e74c3c;
}
</style>
