// このファイルはページを上部まで戻すトグルスイッチを実装するために作りました
document.addEventListener('turbolinks:load', function() {
  // トップまで戻るボタン追随
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('.back-to-top').fadeIn();
    } else {
      $('.back-to-top').fadeOut();
    }
  });

  // トップまで戻るボタンのクリックイベント
  $('.back-to-top').click(function() {
    $('body,html').animate({
      scrollTop: 0
    }, 800);
    return false;
  });
});
