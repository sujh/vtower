// module.exports = {
//   test: /\.vue(\.erb)?$/,
//   use: [
//     {
//       loader: 'vue-loader',
//     },
//     {
//       loader: 'rails-erb-loader',
//       options: {
//         runner: 'bin/rails runner',
//         dependenciesRoot: '../app'
//       }
//     }
//   ]
// }
module.exports = {
  test: /\.vue(\.erb)?$/,
  use: [{
    loader: 'vue-loader'
  }]
}