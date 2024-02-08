// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// bootstrap導入
import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

Rails.start()
Turbolinks.start()
ActiveStorage.start()



// Turbolinksを使用している場合のインライン編集に関するイベントハンドラー
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.edit-comment-link').forEach(function(link) {
    link.addEventListener('click', function(e) {
      e.preventDefault();

      var commentId = this.dataset.commentId;
      var commentElement = document.getElementById('comment-' + commentId);
      var editFormElement = document.getElementById('edit-comment-' + commentId);

      // コメント表示を非表示にして、編集フォームを表示
      if (commentElement && editFormElement) {
        commentElement.style.display = 'none';
        editFormElement.style.display = 'block';
      }
    });
  });
});

// Turbolinksを使用している場合の更新に関するイベントハンドラー
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.update-comment-button').forEach(function(button) {
    button.addEventListener('click', function(e) {
      e.preventDefault();

      var form = this.closest('form');
      var formData = new FormData(form);
      var action = form.getAttribute('action');
      
      Rails.ajax({
        url: action,
        type: 'POST',
        data: formData,
        dataType: 'script',
      });
    });
  });
});
