//= require toastr/toastr.min.js
//= require jasny/jasny-bootstrap.min.js

document.addEventListener("turbolinks:load", function() {

    function updateForm(params) {
        $('.edit-form form').attr("method", params.method);
        $('.edit-form form').attr("action", params.action);
        $('.bootsy_text_area')[0].name = params.bodyName
    };

    $('#new-answer').on('click', function () {
        updateForm({
            method: "post",
            action: "/questions/" + $('#new-answer').data('questionId') + "/answers",
            bodyName: "answer[body]"
        });
    });

    $('#edit-question').on('click', function () {
        updateForm({
            method: "patch",
            action: "/questions/" + $('#edit-question').data('questionId') +"/update_body",
            bodyName: "question[body]"
        });
        $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$('#question-body').html();
    });

    $(document).on('click', '#edit-answer', {}, function () {
        updateForm({
            method: "patch",
            action: "/questions/" + this.dataset.questionId + "/answers/" + this.dataset.answerId,
            bodyName: "answer[body]"
        });
        var selector = '#answer-body[data-answer-id="' + this.dataset.answerId + '"]';
        $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$(selector)[0].innerHTML;
    });

    // Voting
    $('a#question-upvote').on('ajax:success', function (e, data, status, xhr) {
        $('div#question-score')[0].innerText = xhr.responseJSON.score;
    });

    $('a#question-downvote').on('ajax:success', function (e, data, status, xhr) {
        $('div#question-score')[0].innerText = xhr.responseJSON.score;
    });
});