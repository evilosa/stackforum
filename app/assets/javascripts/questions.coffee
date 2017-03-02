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

  newAnswerBtn.on 'click', () ->
    updateForm({
      method: "post",
      action: "/questions/#{newAnswerBtn.data('questionId')}/answers",
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

  editQuestionBtn.on 'click', () ->
    updateForm({
      method: "patch",
      action: "/questions/#{editQuestionBtn.data('questionId')}/update_body",
      bodyName: "question[body]"
    })
    $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=$('#question-body').html()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      $('#questions-list').append(data)
  })
