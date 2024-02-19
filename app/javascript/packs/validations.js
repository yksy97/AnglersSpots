// このファイルはBootstrap4.6.2を用いてカスタムした入力フォームにバリデーションのメッセージ表示する際に使用します。
// public/view/posts/index.html.erb

document.addEventListener('DOMContentLoaded', () => {
  const forms = document.getElementsByClassName('needs-validation');

  Array.prototype.filter.call(forms, (form) => {
    form.addEventListener('submit', (event) => {
      if (form.checkValidity() === false) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  });
});
