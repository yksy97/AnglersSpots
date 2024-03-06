document.addEventListener("DOMContentLoaded", function() {
  // 全ての入力フィールドを取得
  const inputs = document.querySelectorAll('input, textarea, select');
  // パスワードフィールドを取得
  const passwordField = document.getElementById('password');
  // パスワード確認フィールドを取得
  const passwordConfirmationField = document.getElementById('password_confirmation');
  // パスワード確認フィードバック要素を取得
  const passwordConfirmFeedback = document.getElementById('password-confirm-feedback');
  // 送信ボタンを取得
  const submitButton = document.querySelector('input[type="submit"]');
  // フォーム要素を取得
  const form = document.getElementById('signup-form');

  // 送信ボタンの状態を更新する関数
  function updateSubmitButtonState() {
    // フォームのバリデーション状態に基づいて送信ボタンの無効化を切り替える
    submitButton.disabled = !form.checkValidity();
  }

  // 各入力フィールドに対してのイベントリスナーを設定
  inputs.forEach(function(input) {
    input.addEventListener('input', function() {
      // 入力フィールドのバリデーション状態をチェック
      validateField(input);
      // 送信ボタンの状態を更新
      updateSubmitButtonState();
    });
  });

  // 入力フィールドのバリデーション状態に基づいてスタイルを更新する関数
  function validateField(field) {
    if (field.checkValidity()) {
      field.classList.remove('is-invalid');
      field.classList.add('is-valid');
    } else {
      field.classList.remove('is-valid');
      field.classList.add('is-invalid');
    }
  }

  // フォーム送信時のイベントハンドラー
  form.addEventListener('submit', function(event) {
    // パスワードとパスワード確認が一致するかチェック
    if (passwordField.value !== passwordConfirmationField.value) {
      passwordConfirmationField.setCustomValidity('パスワードが一致しません');
      passwordConfirmationField.classList.add('is-invalid');
      passwordConfirmFeedback.style.display = 'block';
      event.preventDefault();
    } else {
      passwordConfirmationField.setCustomValidity('');
      passwordConfirmationField.classList.remove('is-invalid');
      passwordConfirmFeedback.style.display = 'none';
    }
    // 送信ボタンの状態を更新
    updateSubmitButtonState();
  });

  // パスワード確認フィールドの入力内容が変更されたときのイベントハンドラー
  passwordConfirmationField.addEventListener('input', function() {
    if (this.value === passwordField.value) {
      this.setCustomValidity('');
      this.classList.remove('is-invalid');
      this.classList.add('is-valid');
      passwordConfirmFeedback.style.display = 'none';
    } else {
      this.classList.remove('is-valid');
      this.classList.add('is-invalid');
      passwordConfirmFeedback.style.display = 'block';
    }
    // 送信ボタンの状態を更新
    updateSubmitButtonState();
  });

  // パスワードフィールドの入力内容が変更されたときのイベントハンドラー
  passwordField.addEventListener('input', function() {
    if (this.value.length >= 6) {
      validateField(this);
    } else {
      this.classList.remove('is-valid');
      this.classList.add('is-invalid');
    }
    // 送信ボタンの状態を更新
    updateSubmitButtonState();
  });

  // 初期状態で送信ボタンの状態を更新
  updateSubmitButtonState();
});