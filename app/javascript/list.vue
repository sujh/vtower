<template>
  <div>
    <h2 style="display: inline-block">{{plan.title}}</h2>
    <span>{{plan.description}}</span>

    <div class="flex-container">
      <div v-for="list in lists" class="item">
        <div v-show="!list.editShow">
          <span>{{list.title}}</span>
          <button @click="toggle(list)">编辑</button>
          <button @click="deleteList(list)">删除</button>
          <button @click="addTask(list)">添加任务</button>
        </div>
        <div v-show="list.editShow" class="editField">
          <input type="text" :value="list.title">
          <button @click="updateList(list, $event)">确定</button>
          <button @click="toggle(list)">取消</button>
        </div>
      </div>

      <div class="item">
        <a v-if="!newList.show" @click="newList.show = true" href="javascript:;">添加任务组</a>
        <div v-else>
          <input type="text" placeholder="标题" v-model="newList.title">
          <button @click="newList.show = false">取消</button>
          <button @click="createList">提交</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
  export default {
    data() {
      return {
        plan: {
          title: null,
          description: null,
          id: null
        },
        newList: {
          title: null,
          show: false
        },
        lists: []
      }
    },
    created: function(){
      $axios.get(window.location.href + '.json').then((resp) => {
        Object.assign(this.plan, resp.data.data.plan)
        this.lists.push(...resp.data.data.lists)
      })
    },
    methods: {
      createList(){
        $axios.post('/lists', { title: this.newList.title, plan_id: this.plan.id }).then((resp) => {
          if (resp.data.status === 0) {
            this.lists.push({id: resp.data.data.id, title: this.newList.title})
            this.newList.show = false
          } else {
            alert(resp.data.msg)
          }
        })
      },
      toggle(list){
        if(list.editShow) {
          this.$set(list, 'editShow', false)
        } else {
          this.$set(list, 'editShow', true)
        }
      },
      updateList(list, event){
        let title = event.target.closest('.editField').querySelector('input').value
        $axios.patch(`/lists/${list.id}`, { title: title }).then((resp) => {
          if (resp.data.status === 0) {
            this.toggle(list)
            list.title = title
          } else {
            alert(resp.data.msg)
          }
        })
      },
      deleteList(list){
        if(confirm(`确认删除${list.title}？`)){
          $axios.delete(`/lists/${list.id}`).then((resp) => {
            this.lists.splice(this.lists.indexOf(list), 1)
          })
        }
      },
      addTask(list){
        
      }
    }
  }
</script>

<style>
  .flex-container {
    flex-wrap: wrap;
    display: flex;
  }

  .item {
    width: 300px;
    margin: 10px 20px;
  }
</style>