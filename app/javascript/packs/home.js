import Vue from 'vue/dist/vue.esm'
import Home from '../home'
import Element from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(Element)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(Home)
  }).$mount()
  document.body.appendChild(app.$el)
})
