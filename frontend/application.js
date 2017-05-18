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
import Practice from './components/practice.vue'
import FretBoard from './components/fret-board.vue'
import Error from './components/error.vue'

// ROUTES
const routes = [
  { path: `/chord-practice`, component: Chords },
  { path: `/chord-practice/sessions/:id`, component: Practice },
  { path: `/chord-practice/sessions`, component: Sessions }
];
const router = new VueRouter({
  mode: 'history',
  routes
});

// Add Rails' CSRF token header to requests
Axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
Axios.defaults.baseURL = "/chord-practice";

// Register child components
Vue.component('fret-board', FretBoard);
Vue.component('error', Error);

// GLOBAL COMPONENT
const app = new Vue({
  router,
  render: h => h(Main)
}).$mount('#app');
