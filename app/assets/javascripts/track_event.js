$(document).ready(function(){
  $("[track-event]").on("click", function(e){
    analytics.track(
      this.dataset.subject,
      {
        category: this.dataset.category,
        label: this.dataset.label,
      }
    );
  });
});
