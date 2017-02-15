//= require toastr/toastr.min.js

document.addEventListener("turbolinks:load", function() {

    $('#new-answer').on('click', function () {
        $('.edit-form form').attr("method", "post");
        $('.edit-form form').attr("action", "/questions/" + $('#new-answer').data('questionId') + "/answers");
        $('.bootsy_text_area')[0].name = "answer[body]"
    });

    $('#edit-question').on('click', function () {
        $('.edit-form form').attr("method", "patch");
        $('.edit-form form').attr("action", "/questions/" + $('#edit-question').data('questionId') +"/update_body" );
        $('.bootsy_text_area')[0].name = "question[body]"
        $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$('#question-body').html();
    });

    $(document).on('click', '#edit-answer', {}, function () {
        $('.edit-form form').attr("method", "patch");
        $('.edit-form form').attr("action", "/questions/" + this.dataset.questionId + "/answers/" + this.dataset.answerId );
        $('.bootsy_text_area')[0].name = "answer[body]";
        var selector = '#answer-body[data-answer-id="' + this.dataset.answerId + '"]';
        $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$(selector)[0].innerHTML;
    });
});