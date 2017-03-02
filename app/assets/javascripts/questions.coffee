#= require toastr/toastr.min.js
#= require jasny/jasny-bootstrap.min.js

$ ->

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      $('#questions-list').append(data)
  })

  updateForm = (params) ->
    $('.edit-form form').attr("method", params.method)
    $('.edit-form form').attr("action", params.action)
    $('.bootsy_text_area')[0].name = params.bodyName

  $('#new-answer').bind 'click', () ->
    updateForm({
      method: "post",
      action: "/questions/#{$('#new-answer').data('questionId')}/answers",
      bodyName: "answer[body]"
    })

  $('#edit-question').bind 'click', () ->
    updateForm({
      method: "patch",
      action: "/questions/#{$('#edit-question').data('questionId')}/update_body",
      bodyName: "question[body]"
    })
    $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$('#question-body').html()

  $('edit-answer').bind 'click', () ->
    updateForm({
      method: "patch",
      #action: "/questions/#{this.dataset.questionId}/answers/#{this.dataset.answerId}",
      bodyName: "answer[body]"
    })
    #selector = '#answer-body[data-answer-id="' + this.dataset.answerId + '"]'
    #$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$(selector)[0].innerHTML

