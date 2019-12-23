import Vue from 'vue/dist/vue.esm';
import Home from '../home';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(Home)
  }).$mount()
  document.body.appendChild(app.$el)
})
