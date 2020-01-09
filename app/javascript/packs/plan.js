import Vue from 'vue/dist/vue.esm';
import Plan from '../plan';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(Plan)
  }).$mount()
  document.body.appendChild(app.$el)
})
