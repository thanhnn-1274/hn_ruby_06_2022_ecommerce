global.show_modal = function show_modal() {
  $("#order-modal").modal('show');
}

$(document).on("turbolinks:load", function(){
  show_modal()
});
