$(document).ready(function() {
  $('.btn-subtract-qty').click(function(){
    var $button = $(this);
    var oldValue = parseInt($button.parent().find("input").val());
    if (oldValue > 1)
    {
      $button.parent().find("input").val(oldValue - 1)
    }
  });
  $('.btn-add-qty').click(function(){
    var $button = $(this);
    var inputValue = parseInt($button.parent().find("input").val());
    $button.parent().find("input").val(inputValue + 1)
  });
});
