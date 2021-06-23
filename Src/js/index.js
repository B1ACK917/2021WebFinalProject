function showLoginBox() {
  let main = document.getElementById('main')
  if (!main) return
  main.parentNode.removeChild(main)
  let body = document.querySelector('body')
  let loginFrame = document.createElement('div')
  loginFrame.innerHTML =
    '<form>\
      <div class="login-header">\
        <img src="icons/tabler-icon-activity.png">\
        <p>Login</p>\
      </div>\
      <div class="login-input-box">\
        <i class="fa fa-user" aria-hidden="true" style="width: 20px;"></i>\
        <input type="text" placeholder="账户">\
      </div>\
      <div class="login-input-box">\
        <i class="fa fa-lock" aria-hidden="true" style="width: 20px;"></i>\
        <input type="password" placeholder="密码">\
      </div>\
    </form>\
    <div class="login-button-box">\
      <button>登录</button>\
    </div>\
    <div class="back-arrow">\
      <i class="fa fa-arrow-left" aria-hidden="true" onclick="hideLoginBox()"></i>\
    </div>'
  loginFrame.id = 'loginFrame'
  loginFrame.className = 'animate__animated animate__backInRight'
  body.appendChild(loginFrame)
  moveElementToCenter('loginFrame')
}

function hideLoginBox() {
  let loginFrame = document.getElementById('loginFrame')
  if (!loginFrame) return
  loginFrame.parentNode.removeChild(loginFrame)
  let body = document.querySelector('body')
  let main = document.createElement('div')
  main.innerHTML =
    '<h1 style="text-align: center; color: white; height: 80px; ">上传与分享您的图片</h1>\
    <h3 style="text-align: center; color: white; height: 80px;">\
      任意拖放图片到这里, 即开始上传你的图片. <br>\
      或者点击下面的图标以开始批量上传你的图片.\
    </h3>\
    <div class="upload">\
      <a href="#">\
        <i class="fa fa-cloud-upload" aria-hidden="true"></i>\
        开始上传\
      </a>\
    </div>'
  main.id = 'main'
  body.appendChild(main)
  moveElementToCenter('main')
}

function postAccount() {
  let args = document.getElementById('loginArgs')
  args.submit()
}
