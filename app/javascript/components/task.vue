<template>
  <div>
    <div v-if="newTask.show" class="newTask">
      <input type="text" placeholder="标题" v-model="newTask.title">
      <br>
      <input type="text" placeholder="内容" v-model="newTask.content">
      <br>
      <button @click="createTask">提交</button>
      <button @click="newTask.show=false">取消</button>
    </div>
    <br>
    <div>
      <div v-for="t in tasks" class="taskItem">
        <span v-if="!t.editShow">
          <del v-if="t.status == 'closed'">
            {{t.title}}
          </del>
          <template v-else>{{t.title}}</template>
        </span>
        <div class="editTaskField" v-if="t.editShow">
          <input type="text" :value="t.title" name="title">
          <br>
          <input type="text" :value="t.content" name="content">
          <br>
          <button @click="updateTask(t, $event)">确定</button>
          <button @click="toggleEditField(t)">取消</button>
        </div>
        <span class="taskOptField">
          <button @click="toggleEditField(t)">编辑</button>
          <button @click="delTask(t)">删除</button>
          <button v-if="t.status == 'opened'" @click="changeTaskStatus(t, 'closed')">关闭</button>
          <button v-if="t.status == 'closed'" @click="changeTaskStatus(t, 'opened')">打开</button>
        </span>
      </div>
    </div>

  </div>
</template>

<script>
  export default {
    props: ['list_id', 'tasks'],
    data() {
      return {
        newTask: {
          title: '',
          content: '',
          show: false
        }
      }
    },
    methods: {
      createTask(){
        if(!this.newTask.title){
          alert('标题不能为空')
        } else if(!this.newTask.content){
          alert('内容不能为空')
        } else {
          $axios.post('/tasks', { title: this.newTask.title, content: this.newTask.content, list_id: this.list_id })
            .then((resp) => {
              if(resp.data.status === 0){
                Object.assign(this.newTask, {title: '', content: '', show: false})
                this.tasks.push({title: resp.data.data.title, content: resp.data.data.content, id: resp.data.data.id, status: 'opened'})
              } else {
                alert(resp.data.msg)
              }
            })
        }
      },
      delTask(task){
        if(confirm('确认删除?')){
          $axios.delete(`/tasks/${task.id}`).then((resp) => {
            this.tasks.splice(this.tasks.indexOf(task), 1)
          })
        }
      },
      toggleEditField(task){
        if(task.editShow === undefined){
          this.$set(task, 'editShow', true)
        } else {
          task.editShow = !task.editShow
        }
      },
      updateTask(task, event){
        let pele = event.target.closest('div')
        let title = pele.querySelector('input[name=title]').value
        let content = pele.querySelector('input[name=content]').value
        $axios.patch(`/tasks/${task.id}`, {title, content}).then((resp) => {
          if(resp.data.status === 0){
            Object.assign(task, {title, content})
            this.toggleEditField(task)
          } else {
            alert(resp.data.msg)
          }
        })
      },
      changeTaskStatus(task, status){
        $axios.patch(`/tasks/${task.id}`, {status}).then((resp) => {
          if(resp.data.status === 0){
            task.status = status
          } else {
            alert(resp.data.msg)
          }
        })
      }
    }
  }
</script>

<style>
  .newTask {
    position: absolute;
    width: 300px;
    background-color: white;
  }
  .editTaskField {
    position: absolute;
    background-color: white;
  }
  .taskOptField{
    display: none;
    float: right;
  }
  .taskItem:hover .taskOptField{
    display: inline
  }

</style>