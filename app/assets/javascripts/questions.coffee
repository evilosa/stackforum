#= require toastr/toastr.min.js
#= require jasny/jasny-bootstrap.min.js

$ ->
  editForm = $('.edit-form form')
  newAnswerBtn = $('#new-answer')
  editAnswerBtn = $('edit-answer')
  editQuestionBtn = $('#edit-question')

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

  $(document).on 'click', '#edit-question', () ->
    updateForm({
      method: "patch",
      action: "/questions/#{$('#edit-question').data('questionId')}/update_body",
      bodyName: "question[body]"
    })
    $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$('#question-body').html()

question_channel = ->
  App.cable.subscriptions.unsubscribe

  if (window.location.pathname == '/questions')
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: ->
        @perform 'follow'
      ,
      received: (data) ->
        $('#questions-list').append(data)
      ,
      disconnected: ->
        console.log 'disconnected questions'
    })
  else
    App.cable.subscriptions.create({channel: 'QuestionsChannel', id: $('.social-body').data('questionId')},
      connected: ->
        @perform 'follow_question'
      ,
      received: (data) ->
        console.log data
        $('.social-footer').append(JST["templates/answer/answer"](data))
      ,
      disconnected: ->
        console.log 'disconnected question id'
    )

#$(document).ready(question_channel)
$(document).on('turbolinks:load', question_channel)
#$(document).on('page:update', question_channel)
