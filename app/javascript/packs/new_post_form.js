// 新規投稿モーダル（public/posts/index）におけるJavaScriptのバリデーションとInputイベントリスナーの設定
document.addEventListener('DOMContentLoaded', function() {
  const newGenreBtn = document.getElementById('newGenreBtn');
  const existingGenreBtn = document.getElementById('existingGenreBtn');
  const newGenreInput = document.getElementById('newGenreInput');
  const existingGenreSelect = document.getElementById('existingGenreSelect');
  const form = document.getElementById('NewPostForm');
  const submitBtn = document.getElementById('submitBtn');

  // 新規ボタン
  newGenreBtn.addEventListener('click', function() {
    newGenreInput.style.display = 'block';
    existingGenreSelect.style.display = 'none';
  });

  // 既存ボタン
  existingGenreBtn.addEventListener('click', function() {
    newGenreInput.style.display = 'none';
    existingGenreSelect.style.display = 'block';
  });

  // フォーム内の全入力フィールドにinputイベントリスナーを追加
  // バリデーションでクリア後に当該フォームを修正すると、再び投稿ボタンが押せる
  const inputs = form.querySelectorAll('input, select, textarea');
  inputs.forEach(input => {
    input.addEventListener('input', function() {
      if (form.checkValidity()) {
        submitBtn.disabled = false; // フォームが有効ならボタンを有効化
      } else {
        submitBtn.disabled = true; // フォームが無効ならボタンを無効化
      }
    });
  });

  // フォーム送信時の処理
  form.addEventListener('submit', function(event) {
    const newGenreValue = newGenreInput.querySelector('input').value.trim();
    const existingGenreValue = existingGenreSelect.querySelector('select').value;

    if ((!newGenreValue && !existingGenreValue) || !form.checkValidity()) {
      event.preventDefault(); // フォームの送信を阻止＝投稿ボタンが押せなくなる
      alert('既存の魚を選択するか、新規の魚を入力してください');
      form.classList.add('was-validated');
    }
  });
});
