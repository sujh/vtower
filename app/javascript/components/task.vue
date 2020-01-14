<template>
  <div>
    <el-form v-if="newTask.show" class="newTask">
      <el-form-item>
        <el-input placeholder="标题" v-model="newTask.title"></el-input>
      </el-form-item>
      <el-form-item>
        <el-input placeholder="内容" v-model="newTask.content" type="textarea"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button @click="createTask">提交</el-button>
        <el-button @click="newTask.show = false">取消</el-button>
      </el-form-item>
    </el-form>
    <div>
      <div v-for="t in tasks" class="taskItem">
        <span v-if="!t.editShow">
          <del v-if="t.status == 'closed'">
            {{t.title}}
          </del>
          <template v-else>{{t.title}}</template>
        </span>
        <el-form class="editTaskField" v-if="t.editShow">
          <el-form-item>
            <el-input placeholder="标题" v-model="t.title"></el-input>
          </el-form-item>
          <el-form-item>
            <el-input placeholder="内容" v-model="t.content"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button @click="updateTask(t)">提交</el-button>
            <el-button @click="cancelTask(t)">取消</el-button>
          </el-form-item>
        </el-form>
        <div class="taskOptField">
          <el-button-group >
            <el-button icon="el-icon-edit" @click="toggleEditField(t)" title="编辑" ></el-button>
            <el-button icon="el-icon-delete" @click="delTask(t)" title="删除"></el-button>
            <el-button @click="changeTaskStatus(t, 'closed')" title="关闭">关闭</el-button>
            <el-button @click="changeTaskStatus(t, 'opened')" title="打开">打开</el-button>
          </el-button-group>
        </div>
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
          task.original = { title: task.title, content: task.content }
        } else {
          task.editShow = !task.editShow
        }
      },
      updateTask(task){
        $axios.patch(`/tasks/${task.id}`, {title: task.title, content: task.content}).then((resp) => {
          if(resp.data.status === 0){
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
      },
      cancelTask(task){
        this.toggleEditField(task)
        Object.assign(task, task.original)
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
  .taskItem{
    margin: 10px 0;
  }

</style>