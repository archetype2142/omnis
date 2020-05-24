
document.querySelector('input#image').addEventListener("change", function(event) {
  event.preventDefault();
  const fileList = this.files;
  let label = document.querySelector('span.file-name')
  label.textContent = fileList[0].name;
})
