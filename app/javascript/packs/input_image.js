
  var dropArea = document.querySelector('.drop-area');
  var inputFile = document.getElementById('inputFile');

  ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
    dropArea.addEventListener(eventName, preventDefaults, false);
  });

  function preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  // ドロップ時の処理
  dropArea.addEventListener('drop', handleDrop, false);

  function handleDrop(e) {
    var dt = e.dataTransfer;
    var files = dt.files;

    inputFile.files = files;

    // ファイル名を表示
    var fileName = files[0].name;
    dropArea.querySelector('.custom-file-label').innerText = fileName;
  }
  inputFile.addEventListener('change', function(e){
    var files = inputFile.files;
    
    var fileName = files[0].name;
    dropArea.querySelector('.custom-file-label').innerText = fileName;
})