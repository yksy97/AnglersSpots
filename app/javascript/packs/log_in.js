document.addEventListener("DOMContentLoaded", function() {
  const loginForm = document.getElementById('login-form');
  const submitButton = loginForm.querySelector('input[type="submit"]');
  const inputs = loginForm.querySelectorAll('input');

  function validateInput(input) {
    if (input.validity.valid) {
      input.classList.add('is-valid');
      input.classList.remove('is-invalid');
    } else {
      input.classList.add('is-invalid');
      input.classList.remove('is-valid');
    }
  }

  function updateSubmitButtonState() {
    const allValid = Array.from(inputs).every(input => input.validity.valid);
    submitButton.disabled = !allValid;
  }

  inputs.forEach(input => {
    input.addEventListener('input', () => {
      validateInput(input);
      updateSubmitButtonState();
    });
  });

  // 初期状態で送信ボタンの状態を更新
  updateSubmitButtonState();
});