// posts/showのリプライ機能
document.addEventListener("DOMContentLoaded", function() {
  // 返信
  document.querySelectorAll(".reply-link").forEach(function(link) {
    link.addEventListener("click", function(e) {
      e.preventDefault();
      var commentId = this.dataset.commentId;
      document.getElementById("reply-form-" + commentId).style.display = "block";
    });
  });

  // 閉じる
  document.querySelectorAll(".close-reply-form").forEach(function(button) {
    button.addEventListener("click", function() {
      var commentId = this.dataset.commentId;
      document.getElementById("reply-form-" + commentId).style.display = "none";
    });
  });
});
