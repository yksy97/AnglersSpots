// posts/showのリプライ機能
document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".reply-link").forEach(function(link) {
    link.addEventListener("click", function(e) {
      e.preventDefault();
      var commentId = this.dataset.commentId;
      document.getElementById("reply-form-" + commentId).style.display = "block";
    });
  });
});