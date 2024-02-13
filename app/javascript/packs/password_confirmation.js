// 新規登録画面で使用
document.addEventListener('turbolinks:load', () => {
  const passwordField = document.querySelector('#password');
  const passwordConfirmationField = document.querySelector('#password_confirmation');
  const form = document.querySelector('#signup-form');

  form.addEventListener('submit', function(event) {
    if (passwordField.value !== passwordConfirmationField.value) {
      passwordConfirmationField.setCustomValidity('パスワードが一致しません');
      event.preventDefault();
      event.stopPropagation();
      passwordConfirmationField.closest('.form-group').querySelector('.invalid-feedback').style.display = 'block';
    } else {
      passwordConfirmationField.setCustomValidity('');
      passwordConfirmationField.closest('.form-group').querySelector('.invalid-feedback').style.display = 'none';
    }
    form.classList.add('was-validated');
  }, false);
});
