$(document).ready(function () {
  var elem_cal = $('#food_record_healthy_score');
  var target_cal = $('#value_cal');
  var cal = ["とてもこってり", "こってり", "まぁまぁこってり", "少しこってり", "普通", "少しヘルシー", "まぁまぁヘルシー", "ヘルシー", "とてもヘルシー"]

  function rangeValue(elem_cal, target_cal) {
    var aaa = parseInt(elem_cal.value) + 4;
    $('#value_cal').html(cal[aaa]);
  }

  $("#food_record_healthy_score").change(function () {
    rangeValue(this);
  });
})

$(document).ready(function () {
  var elem_wl = $('#food_record_workload_score');
  var target_wl = $('#value_wl');
  var wl = ["とても楽", "楽", "まぁまぁ楽", "少し楽", "普通", "少し大変", "まぁまぁ大変", "大変", "とても大変"]

  function rangeValue(elem_wl, target_wl) {
    var aaa = parseInt(elem_wl.value) + 4;
    $('#value_wl').html(wl[aaa]);
  }

  $("#food_record_workload_score").change(function () {
    rangeValue(this);
  });
})

$(document).ready(function () {
  var elem_total = $('#food_record_total_score');
  var target_total = $('#value_total');
  var total = ["☆", "☆☆", "☆☆☆", "☆☆☆☆", "☆☆☆☆☆"]

  function rangeValue(elem_total, target_total) {
    var aaa = parseInt(elem_total.value) - 1;
    $('#value_total').html(total[aaa]);
  }

  $("#food_record_total_score").change(function () {
    rangeValue(this);
  });
})
