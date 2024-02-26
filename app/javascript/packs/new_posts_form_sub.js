// 新規投稿画面のHTMLで使っているjavascriptです（posts/new.html.erb）。
document.addEventListener('DOMContentLoaded', function() {
    const newGenreBtn = document.getElementById('uniqueNewGenreBtn');
    const existingGenreBtn = document.getElementById('uniqueExistingGenreBtn');
    const newGenreInput = document.getElementById('uniqueNewGenreInput');
    const existingGenreSelect = document.getElementById('uniqueExistingGenreSelect');
    const form = document.getElementById('uniqueNewPostForm');
    const submitBtn = document.getElementById('uniqueSubmitBtn');

    // 新規と既存ボタンのイベントリスナー
    newGenreBtn.addEventListener('click', function() {
      newGenreInput.style.display = 'block';
      existingGenreSelect.style.display = 'none';
      submitBtn.disabled = true; // 新規選択時は送信ボタンを無効化
    });

    existingGenreBtn.addEventListener('click', function() {
      newGenreInput.style.display = 'none';
      existingGenreSelect.style.display = 'block';
      submitBtn.disabled = !existingGenreSelect.querySelector('select').value; // 既存選択時は選択状態に応じてボタンの有効化を切り替え
    });

    // フォーム内の全入力フィールドにinputイベントリスナーを追加
    const inputs = form.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
      input.addEventListener('input', function() {
        // 新規名入力または既存選択のいずれかが有効な場合にのみ送信ボタンを有効化
        const isGenreValid = newGenreInput.querySelector('input').value.trim() || existingGenreSelect.querySelector('select').value;
        submitBtn.disabled = !(form.checkValidity() && isGenreValid);
      });
    });

    // フォーム送信時の処理
    form.addEventListener('submit', function(event) {
      const newGenreValue = newGenreInput.querySelector('input').value.trim();
      const existingGenreValue = existingGenreSelect.querySelector('select').value;

      if ((!newGenreValue && !existingGenreValue) || !form.checkValidity()) {
        event.preventDefault(); // フォームの送信を阻止
        alert('既存の魚を選択するか、新規の魚を入力してください');
      }
    });
  });

  // 画像のドラッグ&ドロップ
  document.addEventListener('DOMContentLoaded', function() {
    var dropArea = document.querySelector('.drop-area');
    var inputFile = document.getElementById('uniqueInputFile');

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

    // ファイル選択時の処理
    inputFile.addEventListener('change', function(e) {
      var files = inputFile.files;
      var fileName = files[0].name;
      dropArea.querySelector('.custom-file-label').innerText = fileName;
    });
  });