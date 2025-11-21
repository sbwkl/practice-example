<template>
  <div id="todo-app">
    <div class="container">
      <h1>Todo List</h1>
      <div class="input-group">
        <input type="text" v-model="newTodo.title" @keyup.enter="addTodo" placeholder="Add a new todo...">
        <button @click="addTodo">Add</button>
      </div>
      <ul class="todo-list">
        <li v-for="todo in todos" :key="todo.id" :class="{ completed: todo.status === 'COMPLETED' }">
          <div class="todo-item">
            <input type="checkbox" :checked="todo.status === 'COMPLETED'" @change="toggleTodoStatus(todo)">
            <span v-if="!todo.editing" @dblclick="editTodo(todo)">{{ todo.title }}</span>
            <input v-else type="text" v-model="todo.title" @keyup.enter="updateTodo(todo)" @blur="updateTodo(todo)" ref="editInput">
          </div>
          <button class="delete-btn" @click="deleteTodo(todo.id)">Delete</button>
        </li>
      </ul>
    </div>
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
              status: 'PENDING',
          };
          const response = await api.createTodo(newTodoData);
          this.todos.push({ ...response.data, editing: false });
          this.newTodo.title = '';
        } catch (error) {
          console.error('Error adding todo:', error);
        }
      }
    },
    async deleteTodo(id) {
      try {
        await api.deleteTodo(id);
        this.todos = this.todos.filter(todo => todo.id !== id);
      } catch (error) {
        console.error('Error deleting todo:', error);
      }
    },
    async toggleTodoStatus(todo) {
      const newStatus = todo.status === 'COMPLETED' ? 'PENDING' : 'COMPLETED';
      try {
        const updatedTodo = { ...todo, status: newStatus };
        await api.updateTodo(todo.id, updatedTodo);
        todo.status = newStatus;
      } catch (error) {
        console.error('Error updating todo status:', error);
      }
    },
    editTodo(todo) {
      const index = this.todos.findIndex(t => t.id === todo.id);
      todo.editing = true;
      this.$nextTick(() => {
        if (this.$refs.editInput && this.$refs.editInput[index]) {
          this.$refs.editInput[index].focus();
        }
      });
    },
    async updateTodo(todo) {
      if (!todo.editing) return;
      todo.editing = false;
      try {
        await api.updateTodo(todo.id, { title: todo.title, description: todo.description, status: todo.status });
      } catch (error) {
        console.error('Error updating todo:', error);
        // Optionally revert the change in the UI
        this.fetchTodos();
      }
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  color: #333;
}

h1 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 20px;
}

.input-group {
  display: flex;
  margin-bottom: 20px;
}

.input-group input {
  flex-grow: 1;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px 0 0 4px;
}

.input-group button {
  padding: 10px 20px;
  border: none;
  background-color: #42b983;
  color: white;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
}

.todo-list {
  list-style: none;
  padding: 0;
}

.todo-item {
  display: flex;
  align-items: center;
}

li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background-color: #f9f9f9;
  border-bottom: 1px solid #eee;
}

li.completed span {
  text-decoration: line-through;
  color: #999;
}

.delete-btn {
  background-color: #e74c3c;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}
</style>
