function moveElementToCenter(element_name) {
  var element = document.getElementById(element_name)
  if (!element) return
  element.style.left =
    document.documentElement.clientWidth / 2 - element.clientWidth / 2 + 'px'
  element.style.top =
    document.documentElement.clientHeight / 2 - element.clientHeight / 2 + 'px'
}
