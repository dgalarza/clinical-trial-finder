$(document).ready(function() {
  $('.js-expander-trigger').click(function(){
    var clickType =
      $(this).hasClass("expander-hidden") ? "Click Expand" : "Click Collapse";

    analytics.track(
      clickType,
      { item: this.dataset.expandItem }
    );

    $(this).toggleClass("expander-hidden");
  });
});
