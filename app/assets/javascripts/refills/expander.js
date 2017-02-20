$(document).ready(function() {
  $('.js-expander-trigger').click(function(){
    var clickType =
      $(this).hasClass("expander-hidden") ? "Expanded" : "Collapsed";

    analytics.track(
      this.dataset.expandItem,
      {
        category: clickType,
        label: location.pathname,
      }
    );

    $(this).toggleClass("expander-hidden");
  });
});
