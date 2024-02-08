// このファイルは、 本の詳細画面で感想の編集と更新をインライン編集で行うためにTurbolinksを考慮して作成しました

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

  // Turbolinksを使用している場合の更新に関するイベントハンドラー
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
