<template>
  <div id="app">
    <ol>
      <li v-for="todo in todos">
        <label>
          <input type="checkbox" v-on:change="toggle(todo)" v-bind:checked="todo.done">
          <del v-if="todo.done">{{todo.text}}</del>
          <span v-else>{{todo.text}}</span>
        </label>
      </li>
    </ol>
  </div>
</template>

<script type="text/javascript">
  export default {
    data() {
      return {
        todos: [
          {text: "Learn ", done: false},
          {text: "Learn Vue", done: false},
          {text: "Play around in JSFiddle", done: true},
          {text: "Build something awesome", done: true}
        ]
      }
    },
    mounted(){console.log('mmm', this.$el)},
    methods: {
      toggle: function(todo){
        todo.done = !todo.done
      }
    }
  }
</script>

<style>
  body {
    padding: 20px;
    font-family: Helvetica;
  }

  #app {
    background: #fff;
    border-radius: 4px;
    padding: 20px;
    transition: all 0.2s;
  }

  li {
    margin: 8px 0;
  }

  h2 {
    font-weight: bold;
    margin-bottom: 15px;
  }

  del {
    color: rgba(0, 0, 0, 0.3);
  }
</style>
