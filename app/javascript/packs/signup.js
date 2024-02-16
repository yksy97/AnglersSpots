// このファイルは新規登録の入力フォームをAjaxを用いて表示させるために作りました
import $ from 'jquery';

$(document).on('DOMContentLoaded', function() {
  $('#signup-form').on('submit', function(e) {
    e.preventDefault();

    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      dataType: 'json',

      success: function(data) {
        // 成功時の処理、例えばページリダイレクト
        window.location.href = data.redirect_to;
      },
      error: function(jqXHR, textStatus, errorThrown) {
        if (jqXHR.status === 422) { // Unprocessable Entity
          const errors = jqXHR.responseJSON.errors;
          // エラーメッセージをフォームの近くに表示する処理
          let errorMessages = '';
          errors.forEach(function(error) {
            errorMessages += `<p>${error}</p>`;
          });
          // エラーメッセージを表示する要素を指定、または新しく作成して追加
          $('#signup-errors').html(errorMessages);
        }
      }
    });
  });
});
