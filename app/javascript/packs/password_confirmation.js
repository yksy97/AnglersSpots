document.addEventListener('turbolinks:load', () => {
  const passwordField = document.querySelector('#password');
  const passwordConfirmationField = document.querySelector('#password_confirmation');
  const form = document.querySelector('#signup-form'); // フォームのIDを指定

  form.addEventListener('submit', function(event) {
    // パスワードの値が一致するか確認
    if (passwordField.value !== passwordConfirmationField.value) {
      // 一致しない場合、フォームの送信を阻止
      passwordConfirmationField.setCustomValidity('パスワードが一致しません');
      event.preventDefault();
      event.stopPropagation();
      // エラーメッセージを表示
      passwordConfirmationField.closest('.form-group').querySelector('.invalid-feedback').style.display = 'block';
    } else {
      // 一致する場合、エラーメッセージを非表示にし、フォーム送信を許可
      passwordConfirmationField.setCustomValidity('');
      passwordConfirmationField.closest('.form-group').querySelector('.invalid-feedback').style.display = 'none';
    }
    // Bootstrapのwas-validated クラスを使って、フォームのバリデーション後に任意のメッセージを表示させる
    form.classList.add('was-validated');
  }, false);
});
