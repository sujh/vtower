import Vue from 'vue/dist/vue.esm';
import List from '../list';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(List)
  }).$mount()
  document.body.appendChild(app.$el)
})
