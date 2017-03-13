// VENDOR
import Vue from 'vue'
import Axios from 'axios'

// COMPONENTS
import Chords from './components/chords.vue'
import Sessions from './components/sessions.vue'
import FretBoard from './components/fret-board.vue'

// ROUTES
const routes = {
  '/': Chords,
  '/sessions': Sessions
}

// Add Rails' CSRF token header to requests
Axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

// Register child components
Vue.component('fret-board', FretBoard);

// GLOBAL COMPONENT
const app = new Vue({
  el: '#app',
  data: {
    currentRoute: window.location.pathname
  },
  computed: {
    ViewComponent () {
      return routes[this.currentRoute] || Chords;
    }
  },
  render: function(createElement) {
    return createElement(this.ViewComponent);
  }
});

window.addEventListener('popstate', () => {
  app.currentRoute = window.location.pathname;
})
