//= require toastr/toastr.min.js

document.addEventListener("turbolinks:load", function() {

    $('#new-answer').on('click', function () {
        $('.edit-form form').attr("method", "post");
        $('.edit-form form').attr("action", "/questions/" + $('#new-answer').data('questionId') + "/answers");
        $('.bootsy_text_area')[0].name = "answer[body]"
    });

});