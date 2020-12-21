$(document).on('turbolinks:load', function(){
  // ここからタグ新規作成モーダル
  $('.js-modal-open_new').on('click',function(){
    $('.js-modal_new').fadeIn();
    return false;
  });
  $('.js-modal-close_new').on('click',function(){
    $('.js-modal_new').fadeOut();
    return false;
  });
  // ここまでタグ新規作成モーダル

  // ここからタグ新規作成Ajax
  function createHTML(tag) {
    let html = `<div class="tasks-index-item" id="tag${tag.id}" data-id="${tag.id}" data-name="#${tag.name}" data-tag-count="0">
                      <div class="task-name">
                      <p>${tag.name}</p>
                    </div>
                    <div class="tag_count">
                      <a href="/task_tags/${tag.id}">タスク一覧</a>
                      <p>0件</p>
                    </div>
                    <div class="task-menus tag-index-menu">
                      <a href="/tasks/new?task_tag=${tag.id}">タスク作成
                        <i class="fas fa-pencil-alt"></i>
                      </a>
                      <p class="js-modal-open_edit">
                        <a href="">タグ編集
                          <i class="fas fa-edit"></i>
                        </a>
                      <a data-confirm="タグ「${tag.name}」を削除します。\nタグを削除すると関連するタスクも削除されます。\nタグを削除してよろしいですか？" data-remote="true" rel="nofollow" data-method="delete" href="/task_tags/${tag.id}">
                        <i class="fas fa-trash-alt"></i>
                      </a>
                    </div>
                  </div>`
    return html;
  };

  function buildHTML(tag) {
    let flash =`<div class="flash tag_created"> 新規タグ「${tag.name}」を登録しました。</div>`
    return flash;
  };

  $("#tasktag_input").on("submit", function(e) {
    e.preventDefault();
    let inputText = $("#task_name").val();
    $.ajax({
      url: "/task_tags",
      type: "POST",
      data: { name: inputText },
      dataType: "json"
    })
    .done(function(data) {
      $("#task_name").val("");
      $('.js-modal_new').fadeOut();
      let html = createHTML(data);
      let flash = buildHTML(data);
      $(".task_tags_index").prepend(html);
      $(".tag_changed").append(flash);
      setTimeout(function(){
        $('.tag_created').fadeOut('slow')
      } ,2000);
      setTimeout(function(){
        $(".tag_created").remove();
      }, 4000);
    })
    .fail(function() {
      alert("エラー：タグを登録できませんでした。\n・空白のタグは登録できません。\n・同じ名前のタグは登録できません。\n・31文字以上のタグは登録できません。");
    })
    .always(function() {
      $(".tasktag_form_btn input").prop('disabled', false);
    });
  });
  // ここまでタグ新規作成Ajax]

  // ここからタグ編集モーダル
  $('.js-modal-open_edit').on('click',function(){
    $('.js-modal_edit').fadeIn();
    return false;
  });
  $('.js-modal-close_edit').on('click',function(){
    $('.js-modal_edit').fadeOut();
    return false;
  });
  // ここまでタグ編集モーダル

  // ここからタグ編集Ajax
  $('.js-modal-open_edit').on("click", function() {
    $(this).parents(".tasks-index-item").addClass('InlineEdit-active');
    let tagId = $(this).parents(".tasks-index-item").data('id');
    const getValues = document.getElementById(`tag${tagId}`);
    var values = {
      id:  getValues.dataset.id,
      name: getValues.dataset.name,
      count: getValues.dataset.tagCount
    };

    $('.edit_label input').val(`${values.name}`);

    function reBuild(tag, values) {
      var html = `<div class="tasks-index-item" id="tag${tag.id}" data-id="${tag.id}" data-name="#${tag.name}" data-tag-count=${values.count}"> 
                      <div class="task-name">
                        <p>${tag.name}</p>
                      </div>
                      <div class="tag_count">
                        <a href="/task_tags/${tag.id}">タスク一覧</a>
                        <p>${values.count}件</p>
                      </div>
                      <div class="task-menus tag-index-menu">
                        <a href="/tasks/new?task_tag=${tag.id}">タスク作成
                          <i class="fas fa-pencil-alt"></i>
                        </a>
                        <p class="js-modal-open_edit">
                          <a href="">タグ編集
                            <i class="fas fa-edit"></i>
                          </a>
                        <a data-confirm="タグ「${tag.name}」を削除します。\nタグを削除すると関連するタスクも削除されます。\nタグを削除してよろしいですか？" data-remote="true" rel="nofollow" data-method="delete" href="/task_tags/${tag.id}">
                          <i class="fas fa-trash-alt"></i>
                        </a>
                      </div>
                    </div>`
      return html
    };

    function updateHTML(tag) {
      let flash =`<div class="flash tag_created"> タグ「${tag.name}」に更新しました。</div>`
      return flash;
    };

    $("#tasktag_input_edit").on("submit", function(e) {
      e.preventDefault();
      let inputText = $("#task_name_edit").val();
      $.ajax({
        url: `/task_tags/${values.id}`,
        type: "PATCH",
        data: {
          id: values.id,
          name: inputText
        },
        dataType: "json"
      })
      .done(function(data) {
        $("#task_name_edit").val("");
        $('.js-modal_edit').fadeOut();
        let html = reBuild(data, values);
        let flash = updateHTML(data);
        $('.InlineEdit-active').parent('.edit_point').addClass('mark');
        $('.mark').empty();
        $('.mark').prepend(html);
        $(".edit_point").removeClass('mark');

        // タグ更新のflash表示
        $(".tag_changed").append(flash);
        setTimeout(function(){
          $('.tag_created').fadeOut('slow')
        } ,2000);
        setTimeout(function(){
          $(".tag_created").remove();
        }, 4000);
      })
      .fail(function() {
        alert("エラー：タグを更新できませんでした。\n・空白のタグは登録できません。\n・同じ名前のタグは登録できません。\n・31文字以上のタグは登録できません。");
      })
      .always(function() {
        $(".tasktag_form_btn input").prop('disabled', false);
      });
    });
  });
  // // ここまでタグ編集Ajax
});
