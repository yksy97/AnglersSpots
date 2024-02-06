// このファイルは、新規登録画面でパスワードとパスワード(確認)の値が一致しない場合にエラーメッセージを表示させるために作りました
document.addEventListener('turbolinks:load', () => {
  const passwordField = document.querySelector('#password');
  const passwordConfirmationField = document.querySelector('#password_confirmation');
  const form = document.querySelector('.needs-validation');

  form.addEventListener('submit', function(event) {
    // パスワードの値が一致するか確認
    if (passwordField.value !== passwordConfirmationField.value) {
      // 一致しない場合、フォームの送信を阻止
      passwordConfirmationField.setCustomValidity('パスワードが一致しません');
      event.preventDefault();
      event.stopPropagation();
    } else {
      // 一致する場合
      passwordConfirmationField.setCustomValidity('');
    }
    // Bootstrapのwas-validated クラスを使って、フォームのバリデーション後に任意のメッセージを表示させる
    form.classList.add('was-validated');
  }, false);
});
