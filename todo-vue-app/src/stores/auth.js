import { defineStore } from 'pinia';
import todoService from '../services/todoService';

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || null,
        user: JSON.parse(localStorage.getItem('user')) || null,
    }),
    getters: {
        isAuthenticated: (state) => !!state.token,
    },
    actions: {
        async login(username, password) {
            try {
                const response = await todoService.login({ username, password });
                this.token = response.data.token;
                // Decode token or fetch user details if needed. For now, just storing username.
                this.user = { username };

                localStorage.setItem('token', this.token);
                localStorage.setItem('user', JSON.stringify(this.user));

                // Update axios headers
                todoService.setAuthToken(this.token);

                return true;
            } catch (error) {
                console.error('Login failed:', error);
                throw error;
            }
        },
        logout() {
            this.token = null;
            this.user = null;
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            todoService.setAuthToken(null);
        }
    }
});
