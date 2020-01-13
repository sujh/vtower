import Vue from 'vue/dist/vue.esm';
import Plan from '../plan';
import Element from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(Element, { size: 'mini', zIndex: 3000 })
document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(Plan)
  }).$mount()
  document.body.appendChild(app.$el)
})
