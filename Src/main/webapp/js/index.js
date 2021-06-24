let loginFrameCache
let mainFrameCache

function removeLoginFrame() {
    let loginFrame = document.getElementById('loginFrame')
    if (!loginFrame) return false
    loginFrameCache = loginFrame.innerHTML
    loginFrame.parentNode.removeChild(loginFrame)
    return true
}

function removeMainFrame() {
    let main = document.getElementById('main')
    if (!main) return false
    mainFrameCache = main.innerHTML
    main.parentNode.removeChild(main)
    return true
}

function showLoginBox() {
    if (removeMainFrame()) {
        let body = document.querySelector('body')
        let loginFrame = document.createElement('div')
        loginFrame.innerHTML = loginFrameCache
        loginFrame.id = 'loginFrame'
        loginFrame.className = 'animate__animated animate__backInRight'
        body.appendChild(loginFrame)
        moveElementToCenter('loginFrame')
    }
}

function hideLoginBox() {
    if (removeLoginFrame()) {
        let body = document.querySelector('body')
        let main = document.createElement('div')
        main.innerHTML = mainFrameCache
        main.id = 'main'
        body.appendChild(main)
        moveElementToCenter('main')
    }
}

function postAccount() {
    let args = document.getElementById('loginArgs')
    args.submit()
}

function selectFile() {
    document.getElementById('fileInput').click()
}

function postFile() {
    let fileInput = document.getElementById('fileInput')
    let filename = fileInput.value
    let index = filename.lastIndexOf('.');
    let suffix = filename.substr(index + 1);
    if (suffix in {jpg: true, jpeg: true, png: true})
        document.getElementById('fileUploadForm').submit()
    else return
}

function postLogout() {
    let args = document.getElementById('logoutForm')
    args.submit()
}
