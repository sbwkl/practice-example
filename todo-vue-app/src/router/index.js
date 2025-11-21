import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import LoginView from '../views/LoginView.vue';
import RegisterView from '../views/RegisterView.vue';
import App from '../App.vue'; // We might need a separate Home view, but for now let's see. 
// Actually, App.vue is the root. We should probably move the Todo list to a HomeView.
// But to minimize changes, let's assume App.vue will contain the router-view, 
// and we'll create a HomeView that contains the current App.vue logic?
// Wait, the plan said "Replace static content with <router-view>".
// So I should create a HomeView.vue that has the current App.vue content (minus the router-view part).

// Let's create HomeView.vue first in the next step. For now, I'll define the route.
// I'll assume HomeView exists.

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/login',
            name: 'login',
            component: LoginView
        },
        {
            path: '/register',
            name: 'register',
            component: RegisterView
        },
        {
            path: '/',
            name: 'home',
            component: () => import('../views/HomeView.vue'),
            meta: { requiresAuth: true }
        }
    ]
});

router.beforeEach((to, from, next) => {
    const authStore = useAuthStore();
    if (to.meta.requiresAuth && !authStore.isAuthenticated) {
        next('/login');
    } else {
        next();
    }
});

export default router;
