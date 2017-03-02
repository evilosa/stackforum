$ ->
  $('a#question-upvote').on 'ajax:success', (e, data, status, xhr) ->
    $('div#question-score')[0].innerText = xhr.responseJSON.score;

  $('a#question-upvote').on 'ajax:error', (e, xhr, status, error) ->
    if (xhr.status == 401)
      toastr["error"](xhr.responseJSON.error, "Ошибка")
      $(location).attr('href', '/users/sign_in')

  $('a#question-downvote').on 'ajax:success', (e, data, status, xhr) ->
    $('div#question-score')[0].innerText = xhr.responseJSON.score

  $('a#question-downvote').on 'ajax:error', (e, xhr, status, error) ->
    if (xhr.status == 401)
      toastr["error"](xhr.responseJSON.error, "Ошибка")
      $(location).attr('href', '/users/sign_in')

  $('a#answer-upvote').on 'ajax:success', (e, data, status, xhr) ->
    $("div#answer-score[data-answer-id='#{this.dataset.answerId}']")[0].innerText = xhr.responseJSON.score

  $('a#answer-upvote').on 'ajax:error', (e, xhr, status, error) ->
    if (xhr.status == 401)
      toastr["error"](xhr.responseJSON.error, "Ошибка")
      $(location).attr('href', '/users/sign_in')

  $('a#answer-downvote').on 'ajax:success', (e, data, status, xhr) ->
    $("div#answer-score[data-answer-id='#{this.dataset.answerId}']")[0].innerText = xhr.responseJSON.score

  $('a#answer-downvote').on 'ajax:error', (e, xhr, status, error) ->
    if (xhr.status == 401)
      toastr["error"](xhr.responseJSON.error, "Ошибка")
      $(location).attr('href', '/users/sign_in')