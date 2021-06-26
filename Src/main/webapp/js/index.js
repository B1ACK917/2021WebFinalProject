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

const animateCSS = (elementID, animation, prefix = 'animate__') =>
    new Promise((resolve, reject) => {
        const animationName = `${prefix}${animation}`;
        const node = document.getElementById(elementID);

        node.classList.add(`${prefix}animated`, animationName);

        function handleAnimationEnd(event) {
            event.stopPropagation();
            node.classList.remove(`${prefix}animated`, animationName);
            resolve('Animation ended');
        }

        node.addEventListener('animationend', handleAnimationEnd, {once: true});
    });

function showLoginBox() {
    if (removeMainFrame()) {
        let body = document.querySelector('body')
        let loginFrame = document.createElement('div')
        loginFrame.innerHTML = loginFrameCache
        loginFrame.id = 'loginFrame'
        body.appendChild(loginFrame)
        animateCSS('loginFrame', 'backInRight')
        moveElementToCenter('loginFrame')
    } else {
        let loginFrame = document.getElementById('loginFrame')
        if (document.getElementById('loginFrame') != null)
            animateCSS('loginFrame', 'heartBeat')
    }
}

function hideLoginBox() {
    if (document.getElementById('loginFrame')) {
        animateCSS('loginFrame', 'zoomOutLeft').then(message => {
            if (removeLoginFrame()) {
                let body = document.querySelector('body')
                let main = document.createElement('div')
                main.innerHTML = mainFrameCache
                main.id = 'main'
                body.appendChild(main)
                moveElementToCenter('main')
            }
        })
    }

}

function postAccount() {
    let args = document.getElementById('loginArgs')
    let userName = document.getElementById('userInput').value
    let password = document.getElementById('pwdInput').value
    if (userName === '' || password === '') {
        animateCSS('loginFrame', 'shakeX')
        return
    }
    args.submit()
}

function selectFile() {
    document.getElementById('fileInput').click()
}

function postFile() {
    let fileInput = document.getElementById('fileInput')
    // let filename = fileInput.value
    // let index = filename.lastIndexOf('.');
    // let suffix = filename.substr(index + 1);
    // if (suffix in {jpg: true, jpeg: true, png: true})
    document.getElementById('fileUploadForm').submit()
}

function postLogout() {
    let args = document.getElementById('logoutForm')
    args.submit()
}
