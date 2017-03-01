// VENDOR
import Vue from 'vue'
import Axios from 'axios'

// COMPONENTS
import FretBoard from './components/fret-board.vue'

// Add Rails' CSRF token header to requests
Axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

// GLOBAL COMPONENT
window.myApp = new Vue({
  el: '#app',
  render: function (createElement) {
    return createElement(FretBoard)
  }
})
