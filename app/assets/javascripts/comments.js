// const { data } = require("jquery");

$(document).on('turbolinks:load', function(){
  // ここから日付をYYYY-MM-DDの書式で返すメソッド
  function formatDate(dt) {
    var y = dt.getFullYear();
    var m = ('00' + (dt.getMonth()+1)).slice(-2);
    var d = ('00' + dt.getDate()).slice(-2);
    return (y + '-' + m + '-' + d);
  }
  // ここまで日付をYYYY-MM-DDの書式で返すメソッド

  // ここから文字列内のURLをリンクタグに変換する機能定義
  function AutoLink(str) {
    var regexp_url = /((h?)(ttps?:\/\/[a-zA-Z0-9.\-_@:/~?%&;=+#',()*!]+))/g; // ']))/;
    var regexp_makeLink = function(all, url, h, href) {
        return '<a href="h' + href + '" target="_blank">' + url + '</a>';
    }
    return str.replace(regexp_url, regexp_makeLink);
  };
  // ここまで文字列内のURLをリンクタグに変換する機能定義

  // ここからコメント新規作成Ajax
  // Ajaxで追加するコメント文を作成するfunction
  function createHTML(content) {
    // 挿入するHTML用に日時の表記を変換
    var CreatedAt = new Date(content.created_at);
    var Hours = CreatedAt.getHours();
    var Minutes = (CreatedAt.getMinutes()<10?'0':'') + CreatedAt.getMinutes();

    // コメント内のURLを検索、リンクタグに変換
    var link = AutoLink(content.comment)
    var text = link.replace( /\r?\n/g, '<br />' );

    let html = `<div class="right_block" id="comment${content.id}">
                  <div class="right_comment_block">
                    <div class="right_balloon baloon_comment">
                      ${text}
                    </div>
                  </div>
                  <div class="right_item_block">
                    <div class="comment_destroy_right">
                      <a data-confirm="コメントを削除します。" data-remote="true" rel="nofollow" data-method="delete" href="/meal_comments/${content.id}">
                        <i class="fas fa-trash-alt"></i>
                      </a>
                    </div>
                    <div class="comment_time_right">
                      ${Hours}:${Minutes}
                    </div>
                  </div>
                </div>`
    return html;
  };

  // Ajaxで追加する画像ブロックを作成するfunction
  function createImage(content) {
    // 挿入するHTML用に日時の表記を変換
    var CreatedAt = new Date(content.created_at);
    var Hours = CreatedAt.getHours();
    var Minutes = (CreatedAt.getMinutes()<10?'0':'') + CreatedAt.getMinutes();

    let imageSrc = `<div class="right_block" id="comment${content.id}">
                      <div class="right_balloon" id="image_ballon">
                        <img src="${content.image}">
                      </div>
                      <div class="right_item_block">
                        <div class="comment_destroy_right">
                          <a data-confirm="画像を削除します。" data-remote="true" rel="nofollow" data-method="delete" href="/meal_comments/${content.id}">
                            <i class="fas fa-trash-alt"></i>
                          </a>
                        </div>
                        <div class="comment_time_right">
                        ${Hours}:${Minutes}
                        </div>
                      </div>
                    </div>`
    return imageSrc;
  };

  // Ajaxで追加する日付表示を作成するfunction
  function newDateComment(content) {
    var newDateHTML = `<div class="comment_date" id="comment_date${content}">${content}</div>`
    return newDateHTML;
  };

  // 写真アイコンをクリックしたら、ファイル選択画面が開く
  $('.fa-image').on("click", function(){
    $('#comment_image').trigger("click")
  });

  var selectFile; //選択されたファイル(画像)を保持する変数
  var textValue; //画像選択前に入力されたコメントを保持する変数

  // ファイル選択画面表示時の処理
  $('#comment_image').on('change',function(){
    // ファイルが選択されているかどうかで分岐
    if (Object.keys(this.files).length > 0) {
      selectFile = this.files[0];
      $('.fa-image').css('color', '#4ab37d');
      // テキスト入力を不可にする処理(入力済みの内容を取得保持。)
      $('textarea').prop('disabled', true);
      textValue = $('#comment_text').val();
      $('#comment_text').val("");
      $('textarea').prop('placeholder', "画像選択中");
    } else {
      selectFile = [];
      $('.fa-image').css('color', '');
      // テキスト入力を可能にする処理
      $('textarea').prop('disabled', false);
      $('#comment_text').val(`${textValue}`);
      $('textarea').prop('placeholder', "Aa");
    }
  });

  // 送信ボタンが押された時の処理
  $('#comment-form').on("submit", function(e) {
    e.preventDefault();
    // コメントを追加するタスクのidを取得
    let inputId = $('#current_task_id').val();
    // 入力されたコメントを取得
    let inputText = $('#comment_text').val();

    // 日付情報を挿入するかどうか判断
    var newDate;
    var addDate = formatDate(new Date());
    var dateID = $('.comment_date').last().attr("id");
    if ( $(`#${dateID}`).text() == addDate) {
      newDate = false;
    } else {
      newDate = true;
    };
    
    // コメントが入力されていた場合の処理
    if (inputText) {
      var formText = new FormData();
      formText.append('task_id', inputId);
      formText.append('comment', inputText);
      formText.append('image_exist', false);
      $.ajax({
        url: "/meal_comments",
        type: "POST",
        data: formText,
        dataType: "json",
        processData: false,
        contentType: false
      })
      .done(function(data) {
        // 日付情報を挿入する必要がある場合に以下の処理
        if (newDate) {
          let dateHTML = newDateComment(addDate);
          $(".comment-container").append(dateHTML);
        };

        // 送受信したデータを元に挿入するHTMLを作成、挿入
        $('#comment_text').val("");
        let html = createHTML(data);
        $(".comment-container").append(html);
        // コメントコンテナ内の画面を下までスクロール
        $(".comment-container").scrollTop($(".comment-container")[0].scrollHeight);
      })
      .fail(function(){
        alert("エラー：コメントを登録できませんでした。\n・空白のコメントは登録できません。\n・141文字以上のタグは登録できません。");
      })
      .always(function() {
        $(".comment_form_btn input").prop('disabled', false);
      });
    };

    // 画像が選択されていた場合の処理
    if ($(selectFile).length) {
      // Blobを生成する
      var filetype = selectFile["type"];
      var blob = new Blob([selectFile], {type: filetype});

      var formData = new FormData();
      formData.append('task_id', inputId);
      formData.append('image', blob);
      formData.append('image_exist', true);
      $.ajax({
        url: "/meal_comments",
        type: "POST",
        data: formData,
        dataType: "json",
        processData: false,
        contentType: false
      })
      .done(function(data) {
        // 日付情報を挿入する必要がある場合に以下の処理
        if (newDate) {
          let dateHTML = newDateComment(addDate);
          $(".comment-container").append(dateHTML);
        };

        // 送受信したデータを元に挿入するHTMLを作成、挿入
        let imageBallon = createImage(data);
        $(".comment-container").append(imageBallon);
        // コメントコンテナ内の画面を下までスクロール
        $(".comment-container").scrollTop($(".comment-container")[0].scrollHeight);
      })
      .fail(function(){
        alert("エラー：画像を登録できませんでした。");
      })
      .always(function() {
        $(".comment_form_btn input").prop('disabled', false);
        // 画像選択状態を解除
        selectFile = [];
        $('.fa-image').css('color', '');
        // テキスト入力を可能にする処理
        $('textarea').prop('disabled', false);
        $('#comment_text').val(`${textValue}`);
        $('textarea').prop('placeholder', "Aa");
      });
    };
  });
  // ここまでコメント新規作成Ajax
});

