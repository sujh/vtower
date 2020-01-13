<template>
  <div id="app">
    <div id="plan-list">
      <div class="plan-item" v-for="p in plans" :key="p.id" >
        <div style="position: relative" class="plan-show">
          <a :href="`/plans/${p.id}`" v-show="!p.editShow">
            <el-card>
              {{p.title}}
              <br>
              <br>
              {{p.description}}
            </el-card>
          </a>
          <span class="opt-btn">
            <el-button-group>
              <el-button icon="el-icon-edit" @click="toggleEditPlan(p)" title="编辑"></el-button>
              <el-button icon="el-icon-delete" @click="delPlan(p)" title="删除"></el-button>
            </el-button-group>
          </span>
        </div>

        <el-card class="edit-field" v-show="p.editShow" :data-id="p.id">
          <el-form>
            <el-form-item>
              <el-input type="text" placeholder="名称" :value="p.title"></el-input>
            </el-form-item>
            <el-form-item>
              <el-input type="text" placeholder="描述" :value="p.description"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button @click="updatePlan(p)">提交</el-button>
              <el-button @click="toggleEditPlan(p)">取消</el-button>
              <span>{{p.error_msg}}</span>
            </el-form-item>
          </el-form>
        </el-card>
      </div>

      <el-button class="el-card plan-item" v-if="!plan.show" @click="toggleNewPlan" title="新建">
        <i class="el-icon-document-add" style="font-size: 40px"></i>
      </el-button>

      <el-card class="plan-form plan-item box-card" v-if="plan.show">
        <el-form>
          <el-form-item>
            <el-input v-model='plan.title' type="text" placeholder="名称"></el-input>
          </el-form-item>
          <el-form-item>
            <el-input v-model='plan.description' type="text" placeholder="描述"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button @click="createPlan">提交</el-button>
            <el-button @click="toggleNewPlan">取消</el-button>
            <span>{{plan.error_msg}}</span>
          </el-form-item>
        </el-form>
      </el-card>
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
                this.plans.push({ title: this.plan.title, description: this.plan.description, id: resp.data.data.id })
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
    width: 300px;
    margin: 5px 10px 5px 10px !important;
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
  a {
    text-decoration: none;
  }
</style>