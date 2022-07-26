$(document).ready(function() {
  $('.home-filter .filter-button').on('click', function() {
      $('.filter-button').removeClass('filter-button-active');
      $(this).addClass('filter-button-active');
  });

  $('.category-list .category-item .category-item-link').on('click', function() {
    $('.category-item .category-item-link').removeClass('category-active');
    $(this).addClass('category-active');
  });

});
