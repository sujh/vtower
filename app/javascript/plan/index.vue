<template>
  <div id="app">
    <div id="plan-list">
      <div class="plan-item" v-for="p in plans" :key="p.id" >
        <div style="position: relative" class="plan-show">
          <div v-show="!p.editShow">
            <a :href="`/plans/${p.id}`">
              <div>{{p.title}}</div>
              <div>{{p.description}}</div>
            </a>
          </div>
          <span class="opt-btn">
            <button @click="toggleEditPlan(p)">编辑</button>
            <button @click="delPlan(p)">删除</button>
          </span>
        </div>

        <div class="edit-field" v-show="p.editShow" :data-id="p.id">
          <input type="text" placeholder="名称" :value="p.title">
          <input type="text" placeholder="描述" :value="p.description">
          <div>
            <button @click="updatePlan(p)">提交</button>
            <button @click="toggleEditPlan(p)">取消</button>
            <span>{{p.error_msg}}</span>
          </div>
        </div>
      </div>

      <button class="plan-item" v-if="!plan.show" @click="toggleNewPlan">add</button>
      <div class="plan-form plan-item" v-if="plan.show">
        <div>
          <input v-model='plan.title' type="text" placeholder="名称">
        </div>
        <div>
          <input v-model='plan.description' type="text" placeholder="描述">
        </div>
        <div>
          <button @click="createPlan">提交</button>
          <button @click="toggleNewPlan">取消</button>
          <span>{{plan.error_msg}}</span>
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
          show: false,
          title: '',
          description: '',
          error_msg: null,
        },
        plans: [],
      }
    },
    beforeCreate(){
      $axios.get('/plans.json').then((resp) => this.plans = resp.data.data.plans)
    },

    methods: {
      toggleNewPlan(){
        this.plan.show = !this.plan.show
      },
      createPlan(){
        if (this.plan.title === '') {
          this.plan.error_msg = '名称不能为空'
        } else if (this.plan.description === '') {
          this.plan.error_msg = '描述不能为空'
        } else {
          $axios.post('/plans', { title: this.plan.title, description: this.plan.description })
            .then((resp) => {
              if (resp.data.status === 0) {
                this.plans.push({ title: this.plan.title, description: this.plan.description })
                Object.assign(this.plan, { error_msg: '提交成功', show: false })
              } else {
                this.plan.error_msg = resp.data.msg
              }
            })
        }
      },
      updatePlan(plan){
        let ele = document.querySelector(`[data-id="${plan.id}"]`)
        let title = ele.children[0].value
        let description = ele.children[1].value
        if (title === '') {
          this.$set(plan, 'error_msg', '名称不能为空')
        } else if(description === '') {
          this.$set(plan, 'error_msg', '描述不能为空')
        } else {
          $axios.patch(`/plans/${plan.id}`, {title: title, description: description})
            .then((resp) => {
              if(resp.data.status === 0) {
                Object.assign(plan, { title: title, description: description, error_msg: '提交成功' })
                this.toggleEditPlan(plan)
              } else {
                this.$set(plan, 'error_msg', resp.data.msg)
              }
            })
        }
      },
      delPlan(plan){
        if (window.confirm(`确认删除${plan.title}?`)) {
          $axios.delete(`/plans/${plan.id}`)
            .then((resp) => {
              if (resp.data.status === 0) {
                this.plans.splice(this.plans.indexOf(plan), 1)
              } else {
                this.$set(plan, 'error_msg', resp.data.msg)
              }
            })
        }
      },
      toggleEditPlan(plan){
        if(plan.editShow){
          plan.editShow = false
        } else {
          this.$set(plan, 'editShow', true)
        }
      },
    }

  }
</script>

<style type="text/css">
  #plan-list{
    display: flex;
    flex-wrap: wrap;
  }
  .plan-item{
    display: inline-block;
    min-width: 200px;
    margin: 5px 10px 5px 10px;
    background-color: yellow;
  }
  .edit-field{
    display: flex;
    flex-direction: column;
  }
  .opt-btn{
    position: absolute;
    top: 2px;
    right: 2px;
    display: none;
  }
  .plan-show:hover .opt-btn{
    display: block;
  }
</style>