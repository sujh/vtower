<template>
  <div>
    <h2 style="display: inline-block; margin: 20px">{{plan.title}}</h2>
    <span>{{plan.description}}</span>

    <div class="flex-container">
      <el-card v-for="list, idx in lists" class="list-item">
        <div slot="header" v-show="!list.editShow" class="list-title">
          <span>{{list.title}}</span>
          <span class="list-opt-field">
            <el-button-group>
              <el-button icon="el-icon-edit" @click="toggle(list)" title="编辑" ></el-button>
              <el-button icon="el-icon-delete" @click="deleteList(list)" title="删除"></el-button>
              <el-button icon="el-icon-plus" @click="$refs.task[idx].newTask.show=true" title="添加任务"></el-button>
            </el-button-group>
          </span>
        </div>
        <div slot="header" v-show="list.editShow" class="edit-field">
          <el-form :inline="true">
            <el-form-item>
              <el-input placeholder="任务组名称" v-model="list.title"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button @click="updateList(list)">提交</el-button>
              <el-button @click="cancelEdit(list)">取消</el-button>
            </el-form-item>
          </el-form>
        </div>
        <task ref="task" :list_id="list.id" :tasks="list.tasks"></task>
      </el-card>

      <div class="list-item" style="width: 250px">
        <el-button v-if="!newList.show" @click="newList.show = true" type="info" size="medium" plain>添加任务组</el-button>
        <el-form v-else>
          <el-form-item>
            <el-input placeholder="任务组名称" v-model="newList.title"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button @click="createList">提交</el-button>
            <el-button @click="newList.show = false">取消</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
  import Task from './components/task'
  export default {
    components: {
      Task
    },
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
    beforeCreate(){
      $axios.get(window.location.href + '.json').then((resp) => {
        Object.assign(this.plan, resp.data.data.plan)
        this.lists.push(...resp.data.data.lists)
      }).then(() => {
        this.lists.forEach((list) => { list.original = {title: list.title}})
      })
    },
    methods: {
      createList(){
        $axios.post('/lists', { title: this.newList.title, plan_id: this.plan.id }).then((resp) => {
          if (resp.data.status === 0) {
            this.lists.push({id: resp.data.data.id, title: this.newList.title, tasks: []})
            Object.assign(this.newList, {title: null, show: false})
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
      updateList(list){
        $axios.patch(`/lists/${list.id}`, { title: list.title }).then((resp) => {
          if (resp.data.status === 0) {
            this.toggle(list)
            list.original.title = list.title
          } else {
            alert(resp.data.msg)
          }
        })
      },
      cancelEdit(list){
        this.toggle(list)
        list.title = list.original.title
      },
      deleteList(list){
        if(confirm(`确认删除${list.title}？`)){
          $axios.delete(`/lists/${list.id}`).then((resp) => {
            this.lists.splice(this.lists.indexOf(list), 1)
          })
        }
      }
    }
  }
</script>

<style>
  .flex-container {
    flex-wrap: wrap;
    display: flex;
  }
  .list-item {
    width: 350px;
    margin: 10px 20px;
  }
  .list-opt-field {
    display: none;
    float: right
  }
  .el-card__header:hover .list-opt-field {
    display: inline;
  }
</style>