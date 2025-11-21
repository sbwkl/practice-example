<template>
  <div class="home">
    <Todo />
  </div>
</template>

<script>
import Todo from '../components/Todo.vue';

export default {
  name: 'HomeView',
  components: {
    Todo
  }
};
</script>

<style scoped>
.home {
  text-align: center;
}
</style>
