$(document).on("click", ".number-overlay", (function() {
  $(this).parents('.format-node').children('.number-input').select();
  $(this).parents('.format-node').children('.number-input').css('color','#000');
  $(this).css('visibility','hidden');
}));

$(document).on("focus", ".number-input", (function() {
  $(this).parents('.format-node').children('.number-overlay').css('visibility','hidden');
  $(this).css('color','#000');
}));

$(document).on("mousedown", ".number-input", (function() {
  if($(this).is(":focus") === false) {
    $(this).parents('.format-node').children('.number-overlay').css('visibility','hidden');
    $(this).css('color','#000');
  }
}));

$(document).on("mouseup", ".number-input", (function() {
  if($(this).is(":focus") === false) {
    $new_value = formatNumber($(this).val());
    $(this).parents('.format-node').children('.number-overlay').text($new_value);
    $(this).css('color',$(this).css("background-color"));
    $(this).parents('.format-node').children('.number-overlay').css('visibility','visible');
  } else {
  }
}));

$(document).on("click", ".difference-overlay", (function() {
  $(this).parents('.format-node').children('.difference-input').select();
  $(this).parents('.format-node').children('.difference-input').css('color','#000');
  $(this).css('visibility','hidden');
}));

$(document).on("focus", ".difference-input", (function() {
  $(this).parents('.format-node').children('.difference-overlay').css('visibility','hidden');
  $(this).css('color','#000');
}));

$(document).on("mousedown", ".difference-input", (function() {
  if($(this).is(":focus") === false) {
    $(this).parents('.format-node').children('.difference-overlay').css('visibility','hidden');
    $(this).css('color','#000');
  }
}));

$(document).on("mouseup", ".difference-input", (function() {
  if($(this).is(":focus") === false) {
    $new_value = formatNumber($(this).val());
    $(this).parents('.format-node').children('.difference-overlay').text($new_value);
    $(this).css('color',$(this).css("background-color"));
    $(this).parents('.format-node').children('.difference-overlay').css('visibility','visible');
    $id = $(this).attr('id');
    if($id.substring($id.length - 6) === "_robot") {
      $id = $id.substring(0, $id.length - 6);
    } else {
      $id = $id.substring(0, $id.length - 7);
    }
    $robot = $('#' + $id + "_robot").val();
    $parlor = $('#' + $id + "_parlor").val();
    $result = $robot - $parlor;
    $result = Math.round($result * 100.0) / 100.0;
    $prefix = false;
      if($id === "cost_milking" ||
      $id === "cost_barn" ||
      $id === "maintenance0" ||
      $id === "maintenance" ||
      $id === "barn_repair") {
        $prefix = true;
      }
    $result = '<strong>' + formatNumber('' + $result, $prefix) + '</strong>';
    $('#diff_' + $id).html($result);
    $(this).trigger('change');
  } else {
  }
}));

$(document).on("blur", " .difference-input", (function() {
  $old_value = $(this).val();
    $new_value = formatNumber($old_value);
    $char_array = $old_value.split('');
    if($old_value.length === 0  ||
      ($char_array[0] === '0' && $char_array[1] !== '.' && $old_value.length > 1 )) {
      $old_value = $(this).attr('value');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value < $(this).attr('min') * 1) {
      $old_value = $(this).attr('min');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value > $(this).attr('max') * 1) {
      $old_value = $(this).attr('max');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    $(this).css('color',$(this).css("background-color"));
    $(this).parents('.format-node').children('.difference-overlay').text($new_value);
    $(this).parents('.format-node').children('.difference-overlay').css('visibility','visible');
  $id = $(this).attr('id');
  if($id.substring($id.length - 6) === "_robot") {
    $id = $id.substring(0, $id.length - 6);
  } else {
    $id = $id.substring(0, $id.length - 7);
  }
  $robot = $('#' + $id + "_robot").val();
  $parlor = $('#' + $id + "_parlor").val();
  $result = $robot - $parlor;
  $result = Math.round($result * 100.0) / 100.0;
  $prefix = false;
    if($id === "cost_milking" ||
    $id === "cost_barn" ||
    $id === "maintenance0" ||
    $id === "maintenance" ||
    $id === "barn_repair") {
      $prefix = true;
    }
  $result = '<strong>' + formatNumber('' + $result, $prefix) + '</strong>';
  $('#diff_' + $id).html($result);
  $(this).trigger('change');
}));

$(document).on("blur", ".number-input", (function() {
    $old_value = $(this).val();
    $new_value = formatNumber($old_value);
    $char_array = $old_value.split('');
    if($old_value.length === 0  ||
      ($char_array[0] === '0' && $char_array[1] !== '.' && $old_value.length > 1 )) {
      $old_value = $(this).attr('value');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value < $(this).attr('min') * 1) {
      $old_value = $(this).attr('min');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value > $(this).attr('max') * 1) {
      $old_value = $(this).attr('max');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    $(this).css('color',$(this).css("background-color"));
    $(this).parents('.format-node').children('.number-overlay').text($new_value);
    $(this).parents('.format-node').children('.number-overlay').css('visibility','visible');
    $(this).trigger('change');
}));

function formatNumber($old_value, $dollar = false) {
  $decimal = '';
  if($old_value % 1 !== 0) {
    $split = $old_value.split('.');
    $old_value = $split[0];
    $decimal = '.' + $split[1];
  }
  $value_length = $old_value.length;
  $char_array = $old_value.split('');
  $new_value = '';
  for($i = 0; $i < $value_length; $i++) {
    $comma = '';
    if(($value_length - ($i + 1)) / 3 % 1 === 0 && $value_length > 3 &&
    $i < $value_length - 1 && $char_array[$i] !== '-') {
      $comma = ',';
    }
    $new_value += $char_array[$i] + $comma ;
  }
  if($dollar) {
    if($char_array[0] === '-') {
      $new_value = $new_value.substring(1);
      return '-$' + $new_value + $decimal;
    }
    return '$' + $new_value + $decimal;
  }
  return $new_value + $decimal;
}

function inputInit() {
  $(".number-input").each(function(index) {
    $old_value = $(this).val();
    $new_value = formatNumber($old_value);
    $char_array = $old_value.split('');
    if($old_value.length === 0  ||
      ($char_array[0] === '0' && $char_array[1] !== '.' && $old_value.length > 1 )) {
      $old_value = $(this).attr('value');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value < $(this).attr('min') * 1) {
      $old_value = $(this).attr('min');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value > $(this).attr('max') * 1) {
      $old_value = $(this).attr('max');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    $(this).css('color',$(this).css("background-color"));
    $(this).parents('.format-node').children('.number-overlay').text($new_value);
    $(this).parents('.format-node').children('.number-overlay').css('visibility','visible');
    $(this).trigger('change');
  });
  /*$(".difference-input").each(function(index) {
    $old_value = $(this).val();
    $new_value = formatNumber($old_value);
    $char_array = $old_value.split('');
    if($old_value.length === 0  ||
      ($char_array[0] === '0' && $char_array[1] !== '.' && $old_value.length > 1 )) {
      $old_value = $(this).attr('value');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value < $(this).attr('min') * 1) {
      $old_value = $(this).attr('min');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    if($old_value > $(this).attr('max') * 1) {
      $old_value = $(this).attr('max');
      $new_value = formatNumber($old_value);
      $(this).val($old_value);
    }
    $(this).css('color','#fff');
    $(this).parents('.format-node').children('.difference-overlay').text($new_value);
    $(this).parents('.format-node').children('.difference-overlay').show();
    $id = $(this).attr('id');
    if($id.substring($id.length - 6) === "_robot") {
      $id = $id.substring(0, $id.length - 6);
    } else {
      $id = $id.substring(0, $id.length - 7);
    }
    $robot = $('#' + $id + "_robot").val();
    $parlor = $('#' + $id + "_parlor").val();
    $result = $robot - $parlor;
    $result = Math.round($result * 100.0) / 100.0;
    $prefix = false;
    if($id === "cost_milking" ||
    $id === "cost_barn" ||
    $id === "maintenance0" ||
    $id === "maintenance" ||
    $id === "barn_repair") {
      $prefix = true;
    }
    $result = '<strong>' + formatNumber('' + $result, $prefix) + '</strong>';
    $('#diff_' + $id).html($result);
  });*/
}

$(document).on("click", "#loginButton-googleAuthUi .btn", (function() {
  Shiny.onInputChange("logging_in", true);
  //alert(request.getRemoteAddr());
}));

$(document).on("change", "#scenario_label-mobile", (function() {
  updateMobileInputs($lastid);
  $lastid = $(this).val();
}));

function updateMobileInputs($columnid) {
  $(".mobile > .number-input").each(function(index) {
    $label = $(this).data("idref");
    $mobileid = $label + $("#scenario_label-mobile").val();
    $desktopid = $label + $columnid;
    $("#"+$desktopid).val($("#"+$label+"-mobile").val());
    $("#"+$label+"-mobile").val($("#"+$mobileid).val());
  });
  inputInit();
}

$( document ).ready(function() {
  inputInit();
  $lastid = 1;
  //updateMobileInputs();
});