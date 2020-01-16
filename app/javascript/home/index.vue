<template>
  <div id="app">
    <el-container>
      <el-aside width="400px">
        <h1>VTower</h1>
        <p>A rails app for practicing Vue, using vue & webpack</p>
      </el-aside>
      <el-main>
        <el-form label-width="80px" action="/users/sign_in" method="post" v-if="login_form">
          <el-form-item label="邮箱">
            <el-input name="user[email]" v-model="user.email"></el-input>
          </el-form-item>
          <el-form-item label="密码">
            <el-input show-password name="user[password]" v-model="user.password"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" native-type="submit" size="small">登  录</el-button>
            <div style="float: right">
              <el-link @click="login_form=!login_form" type="primary">没有账号？点击注册</el-link>
            </div>
          </el-form-item>
        </el-form>

        <el-form label-width="80px" action="/users" method="post" v-else>
          <el-form-item label="邮箱">
            <el-input name="user[email]" v-model="user.email"></el-input>
          </el-form-item>
          <el-form-item label="密码">
            <el-input show-password name="user[password]" v-model="user.password"></el-input>
          </el-form-item>
          <el-form-item label="确认密码">
            <el-input show-password name="user[password_confirmation]" v-model="user.password_confirmation"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" native-type="submit">注册</el-button>
            <div style="float: right">
              <el-link @click="login_form=!login_form" type="primary">返回登录</el-link>
            </div>
          </el-form-item>
        </el-form>
      </el-main>
    </el-container>
  </div>
</template>

<script type="text/javascript">
  export default {
    data() {
      return {
        login_form: true,
        user: {
          email: '',
          password: '',
          password_confirmation: ''
        }
      }
    },
    mounted(){
      this.$nextTick(() =>{
        let token = document.querySelector('meta[name="csrf-token"]').content
        let ele = document.createElement('input')
        Object.assign(ele, {name: 'authenticity_token', value: token, type: 'hidden'})
        document.querySelector('form.el-form').appendChild(ele)
      })
    },
  }
</script>

<style scoped>
  h1 {
    font-size: 60px;
    margin: 30px 0;
  }
  .el-container {
    margin: 40px 200px
  }
  .el-aside {
    margin: 0 50px
  }
  .el-main {
    min-width: 300px;
    max-width: 600px;
  }
</style>