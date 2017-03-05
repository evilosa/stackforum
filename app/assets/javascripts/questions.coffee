#= require toastr/toastr.min.js
#= require jasny/jasny-bootstrap.min.js

$ ->
  editForm = $('.edit-form form')
  editQuestionBtn = $('#edit-question')

  updateForm = (params) ->
    editForm.attr("method", params.method)
    editForm.attr("action", params.action)
    $('.bootsy_text_area')[0].name = params.bodyName

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

$(document).on('turbolinks:load', question_channel)
