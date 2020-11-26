$(document).on('turbolinks:load', function(){
  $('.tag').css({
    'max-height':'60px',
    'overflow':'hidden'
  });

  $('#tagshow_target').hover(function() {
    $('.tag').css({
      'max-height': '',
      'overflow': ''
    });
  }, function() {
    $('.tag').css({
      'max-height':'60px',
      'overflow':'hidden'
    });
  });

  $('.task-index-tag').css('overflow', 'hidden');

  $('.tagindex_target').hover(function() {
    $('.task-index-tag',this).css('overflow', '');
  }, function() {
    $('.task-index-tag',this).css('overflow', 'hidden');
  });
  // ここまでその他タスク詳細画面のタグ背景の高さ変化
});
