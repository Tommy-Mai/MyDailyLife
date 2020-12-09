$(document).on('turbolinks:load', function(){
  // ここから文字列内のURLをリンクタグに変換する機能定義
  function AutoLink(str) {
    var regexp_url = /((h?)(ttps?:\/\/[a-zA-Z0-9.\-_@:/~?%&;=+#',()*!]+))/g; // ']))/;
    var regexp_makeLink = function(all, url, h, href) {
        return '<a href="h' + href + '" target="_blank">' + url + '</a>';
    }
    return str.replace(regexp_url, regexp_makeLink);
  };
  // ここまで文字列内のURLをリンクタグに変換する機能定義

  // ここからメモ新規作成モーダル
  $('#new_memo_trigger').on('click',function(){
    $('.js-modal_new').fadeIn();
    return false;
  });
  $('.js-modal-close_memo-new').on('click',function(){
    $('.js-modal_new').fadeOut();
    return false;
  });
  // ここまでメモ新規作成モーダル

  // ここから詳細表示トグル
  $('.memo-description-item').hide();
  $(document).on("click", '.memo_description-trigger', function() {
    var showID = $(this).attr("id");
    if($(this).children("i").hasClass('fas fa-bars')){
      $(`#memo${showID}`).slideDown();
      $(this).children("i").removeClass('fas fa-bars');
      $(this).children("i").addClass('fas fa-minus');
    } else {
      $(`#memo${showID}`).slideUp();
      $(this).children("i").removeClass('fas fa-minus');
      $(this).children("i").addClass('fas fa-bars');
    };
  });
  // ここまで詳細表示トグル

  // ここからメモ新規作成Ajax
  function createHTML(memo) {
    // コメント内のURLを検索、リンクタグに変換
    var link = AutoLink(memo.description)
    var text = link.replace( /\r?\n/g, '<br />' ); // 改行を維持する
    let html = `<div class="memo_container">
                  <div class="memo-index-item" id="memo-item${memo.id}" data-id="${memo.id}" data-name="${memo.name}" data-description="${memo.description}">
                    <div class="memo-name">
                      ${memo.name}
                    </div>
                    <div class="memo_description-trigger" id="${memo.id}">
                      <i class="fas fa-bars"></i>
                    </div>
                  </div>
                  <div class="memo-description-item" id="memo${memo.id}" style="display: none;">
                    <div class="memo-description">
                      ${text}
                    </div>
                    <div class="memo_trash">
                      <p class="js-modal-open_edit">
                        <a href="">
                          <i class="fas fa-pencil-alt"></i>
                        </a>
                      </p>
                      <a data-confirm="メモを削除してよろしいですか？" data-remote="true" rel="nofollow" data-method="delete" href="/user_memos/${memo.id}">
                        <i class="fas fa-trash-alt"></i>
                      </a>
                    </div>
                  </div>
                </div>`
    return html;
  };

  function buildHTML(memo) {
    let flash =`<div class="flash tag_created"> 新規メモ「${memo.name}」を登録しました。</div>`
    return flash;
  };

  $("#memo_input").on("submit", function(e) {
    e.preventDefault();
    let inputName = $("#memo_name").val();
    let inputText = $("#memo_description").val();
    $.ajax({
      url: "/user_memos",
      type: "POST",
      data: {
        name: inputName,
        description: inputText
      },
      dataType: "json"
    })
    .done(function(data) {
      $("#memo_name").val("");
      $("#memo_description").val("");
      $('.js-modal_new').fadeOut();
      let html = createHTML(data);
      let flash = buildHTML(data);
      $(".memo_append-point").prepend(html);
      $(".tag_changed").append(flash);
      setTimeout(function(){
        $('.tag_created').fadeOut('slow')
      } ,2000);
      setTimeout(function(){
        $(".tag_created").remove();
      }, 4000);
    })
    .fail(function() {
      alert("エラー：メモを登録できませんでした。\n・空白のメモは登録できません。");
    })
    .always(function() {
      $(".tasktag_form_btn input").prop('disabled', false);
    });
  });
  // ここまでメモ新規作成Ajax

  // ここからメモ編集モーダル
  $(document).on('click', '.js-modal-open_memo-edit', function(){
    $('.js-modal_edit').fadeIn();
    return false;
  });
  $(document).on('click', '.js-modal-close_memo-edit', function(){
    $('.js-modal_edit').fadeOut();
    return false;
  });
  // ここまでメモ編集モーダル

  // ここからメモ編集Ajax
  $(document).on("click", '.js-modal-open_memo-edit', function() {
    $(this).parents(".memo_container").addClass('InlineEdit-active');
    let memoID = $(this).parents(".memo_container").data('id');
    console.log(memoID)
    const getValues = document.getElementById(`memoItem${memoID}`);
    console.log(getValues)
    var values = {
      id: getValues.dataset.id,
      name: getValues.dataset.name,
      description: getValues.dataset.description
    };

    $('.edit_label input').val(`${values.name}`);
    $('.edit_label_description textarea').val(`${values.description}`);

    function reBuild(memo) {
      // コメント内のURLを検索、リンクタグに変換
    var link = AutoLink(memo.description)
    var text = link.replace( /\r?\n/g, '<br />' ); // 改行を維持する
      let html = `<div class="memo_container">
                  <div class="memo-index-item" id="memo-item${memo.id}" data-id="${memo.id}" data-name="${memo.name}" data-description="${memo.description}">
                    <div class="memo-name">
                      ${memo.name}
                    </div>
                    <div class="memo_description-trigger" id="${memo.id}">
                      <i class="fas fa-minus"></i>
                    </div>
                  </div>
                  <div class="memo-description-item" id="memo${memo.id}" style="display: block;">
                    <div class="memo-description">
                      ${text}
                    </div>
                    <div class="memo_trash">
                      <p class="js-modal-open_edit">
                        <a href="">
                          <i class="fas fa-pencil-alt"></i>
                        </a>
                      </p>
                      <a data-confirm="メモを削除してよろしいですか？" data-remote="true" rel="nofollow" data-method="delete" href="/user_memos/${memo.id}">
                        <i class="fas fa-trash-alt"></i>
                      </a>
                    </div>
                  </div>
                </div>`
      return html;
    };

    function updateHTML(memo) {
      let flash =`<div class="flash tag_created"> メモ「${memo.name}」を更新しました。</div>`
      return flash;
    };

    $("#memo_input_memo-edit").on("submit", function(e) {
      e.preventDefault();
      let inputName = $("#memo_name_edit").val();
      let inputText = $("#memo_description_edit").val();
      $.ajax({
        url: `/user_memos/${values.id}`,
        type: "PUT",
        data: {
          id: values.id,
          name: inputName,
          description: inputText
        },
        dataType: "json"
      })
      .done(function(data) {
        $("#memo_name_edit").val("");
        $("#memo_description_edit").val("");
        $('.js-modal_edit').fadeOut();
        let html = reBuild(data);
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
        alert("エラー：メモを更新できませんでした。\n・空白のメモは登録できません。");
      })
      .always(function() {
        $(".tasktag_form_btn input").prop('disabled', false);
      });
    });
  });
  // ここまでメモ編集Ajax
});