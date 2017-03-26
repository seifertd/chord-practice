// VENDOR
import Vue from 'vue'
import VueRouter from 'vue-router'
import Axios from 'axios'

// Vue EXTENSIONS
Vue.use(VueRouter)

// COMPONENTS
import Main from './components/main.vue'
import Chords from './components/chords.vue'
import Sessions from './components/sessions.vue'
import FretBoard from './components/fret-board.vue'

// ROUTES
const routes = [
  { path: '/', component: Chords },
  { path: '/sessions', component: Sessions }
];
const router = new VueRouter({
  mode: 'history',
  routes
});

// Add Rails' CSRF token header to requests
Axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

// Register child components
Vue.component('fret-board', FretBoard);

// GLOBAL COMPONENT
const app = new Vue({
  router,
  render: h => h(Main)
}).$mount('#app');
