$(document).on('turbolinks:load', function () {

  /* ------------------------------
  Loading イメージ表示関数
  引数： msg 画面に表示する文言
  ------------------------------ */
  function dispLoading(msg) {
    // 引数なし（メッセージなし）を許容
    if (msg == undefined) {
      msg = "";
    }
    // 画面表示メッセージ
    var dispMsg = "<div class='loadingMsg'>" + msg + "</div>";
    // ローディング画像が表示されていない場合のみ出力
    if ($("#loading").length == 0) {
      $("body").append("<div id='loading'>" + dispMsg + "</div>");
    }
  }

  /* ------------------------------
  Loading イメージ削除関数
  ------------------------------ */
  function removeLoading() {
    $("#loading").remove();
  }

  /* ------------------------------
  readURL 画像のプレビュー表示とAjax通信処理
  ------------------------------ */
  function readURL(input) {
    $('#image_img_prev').attr('src', '');
    $('#foodrecord_tags').val("");

    if (input.files && input.files[0]) {
      // 処理前に Loading 画像を表示
      dispLoading("解析中...");
      var reader = new FileReader();
      var file = input.files[0];

      // 読み込みが完了したら処理が実行されます
      reader.onload = function (e) {
        //formDataでアップロードされたファイルを開く
        var formData = new FormData();
        formData.append("image_cache", file);
        //ajax通信処理
        $.ajax({
          url: "/food_records/check_cache_image",
          type: "POST",
          data: formData,
          dataType: "json",
          processData: false,
          contentType: false,
        }).done(function (data) {
          var tag_list = data.data.tag_list
          var image_flag = data.data.image_flag
          if (image_flag == true) {
            $('#checkfood').html('');
            //ラベルを元にタグを作成する
            var getData
            $.each(tag_list, function (index, tag) {
              getData = String($("#sampletext").val());
              if (getData == "undefined") {
                getData = ""
              }
              $('input[name="food_record[tag_list]"]').val(getData + tag + ",");
            })
            $('#checkfood').html('解析結果：OK');
            $('.actions input').prop("disabled", false);
          } else {
            $('#checkfood').html('解析結果：料理の写真ではありません。写真を変更してください。');
            $('.actions input').prop("disabled", true);
          }
        }).fail(function () {
          //エラーの場合、アラートを出す。
          alert('画像の読み込みに失敗しました');
        }).always(function () {
          // Lading 画像を消す
          removeLoading();
        })
        //画像プレビューを行う
        $('#image_img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  //画像が選択されると発火
  $("#food_img").change(function () {
    readURL(this);
  });
})
