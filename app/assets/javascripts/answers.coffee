$ ->
  editForm = $('.edit-form form')
  newAnswerBtn = $('#new-answer')
  editAnswerBtn = $('edit-answer')

  updateForm = (params) ->
    editForm.attr("method", params.method)
    editForm.attr("action", params.action)
    $('.bootsy_text_area')[0].name = params.bodyName

  $(document).on 'click', '#new-answer', () ->
    updateForm({
      method: "post",
      action: "/questions/#{$('#new-answer').data('questionId')}/answers",
      bodyName: "answer[body]"
    })

  $(document).on 'click', '#edit-answer', () ->
    updateForm({
      method: "patch",
      action: "/questions/#{this.dataset.questionId}/answers/#{this.dataset.answerId}",
      bodyName: "answer[body]"
    })
    selector = '#answer-body[data-answer-id="' + this.dataset.answerId + '"]'
    $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$(selector)[0].innerHTML

answer_channel = ->
  if (window.location.pathname != '/questions')
    App.cable.subscriptions.create({channel: 'AnswersChannel', id: $('.social-body').data('questionId')},
      connected: ->
        @perform 'follow_question_answers'
      ,
      received: (data) ->
        console.log 'Answers channel activated!'

        switch data.action
          when 'create_answer' then append_answer(data)
      ,
      disconnected: ->
        console.log 'Disconnected from answers channel!'
    )

append_answer = (data) ->
  $('.social-footer').append(JST["templates/answer/answer"](data))
  $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='';

#$(document).ready(question_channel)
$(document).on('turbolinks:load', answer_channel)