#= require toastr/toastr.min.js
#= require jasny/jasny-bootstrap.min.js

$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected!'
  })

  updateForm = (params) ->
    $('.edit-form form').attr("method", params.method);
    $('.edit-form form').attr("action", params.action);
    $('.bootsy_text_area')[0].name = params.bodyName

  $('#new-answer').on('click', () ->
    updateForm({
      method: "post",
      action: "/questions/" + $('#new-answer').data('questionId') + "/answers",
      bodyName: "answer[body]"
    })
  )

  $('#edit-question').on('click', () ->
    updateForm({
      method: "patch",
      action: "/questions/" + $('#edit-question').data('questionId') +"/update_body",
      bodyName: "question[body]"
    })
    $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$('#question-body').html()
  )