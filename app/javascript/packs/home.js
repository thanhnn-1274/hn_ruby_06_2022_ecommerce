$(document).ready(function() {
  $('.home-filter .filter-button').on('click', function() {
      $('.filter-button').removeClass('filter-button-active');
      $(this).addClass('filter-button-active');
  });

  $('.category-list .category-item .category-item-link').on('click', function() {
    $('.category-item .category-item-link').removeClass('category-active');
    $(this).addClass('category-active');
  });

  $('td .form-check-input').change(function(){
    $(this).parent().submit();
  });

  $('.order_search :input').on('click', function() {
    $('.order_search input').removeClass('active');
    $(this).addClass('active');
  });

});
