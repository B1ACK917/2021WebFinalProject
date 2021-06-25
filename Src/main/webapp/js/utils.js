function moveElementToCenter(element_name) {
    var element = document.getElementById(element_name)
    if (!element) return
    element.style.left =
        document.documentElement.clientWidth / 2 - element.clientWidth / 2 + 'px'
    element.style.top =
        document.documentElement.clientHeight / 2 - element.clientHeight / 2 + 'px'
}

function removeAnchorDecoration(className) {
    let elements = document.querySelectorAll(className)
    elements.forEach(element => {
        // console.log(element.src.slice(-8))
        if (element.src.slice(-8) === "alp0.png") {
            element.parentNode.style="cursor: default;"
            element.parentNode.href="###"
        }
    })
}