var CustomerDropArea = document.querySelector('.customer-drop-area');
var CustomerInputFile = document.getElementById('inputCustomerFile');

['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
  CustomerDropArea.addEventListener(eventName, preventDefaults, false);
});

function preventDefaults(e) {
  e.preventDefault();
  e.stopPropagation();
}

// ドロップ時の処理
CustomerDropArea.addEventListener('drop', handleDrop, false);

function handleDrop(e) {
  var dt = e.dataTransfer;
  var files = dt.files;

  CustomerInputFile.files = files;

  // ファイル名を表示
  var fileName = files[0].name;
  CustomerDropArea.querySelector('.custom-file-label').innerText = fileName;
}

CustomerInputFile.addEventListener('change', function(e){
  var files = CustomerInputFile.files;
  var fileName = files[0].name;
  CustomerDropArea.querySelector('.custom-file-label').innerText = fileName;
});