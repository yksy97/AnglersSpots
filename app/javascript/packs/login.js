// このファイルはログイン画面の入力フォームをAjaxを用いて表示させるために作りました
import $ from 'jquery';

$(document).on('turbolinks:load', function() {
  $('#login-form').on('submit', function(e) {
    e.preventDefault();

    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      dataType: 'json',

      success: function(data) {
      },
      error: function(jqXHR, textStatus, errorThrown) {
      }
    });
  });
});