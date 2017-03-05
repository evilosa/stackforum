$ ->
  updateForm = (params) ->
    $('.edit-form form').attr("method", params.method)
    $('.edit-form form').attr("action", params.action)
    $('.bootsy_text_area')[0].name = params.bodyName

  $(document).on 'click', '#new-answer-comment', () ->
    updateForm({
      method: "post",
      action: "/questions/#{this.dataset.questionId}/answers/#{this.dataset.answerId}/comment",
      bodyName: "comment[body]"
    })

  $(document).on 'click', '#new-question-comment', () ->
    updateForm({
      method: "post",
      action: "/questions/#{this.dataset.questionId}/comment",
      bodyName: "comment[body]"
    })

  true

comment_channel = ->

  App.cable.subscriptions.create({channel: 'CommentsChannel', id: $('.social-body').data('questionId') },
    connected: ->
      @perform 'follow_question_comments'
    ,
    received: (data) ->
      console.log 'Comments channel activated!'

      switch data.action
        when 'create_question_comment' then append_question_comment(data)
        when 'create_answer_comment' then append_answer_comment(data)
    ,
    disconnected: ->
      console.log 'disconnected question id'
  )

append_question_comment = (data) ->
  $('.comments[data-question-id="' + data.owner_id + '"]').append(JST["templates/comments/comment"](data))
  $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=''

append_answer_comment = (data) ->
  $('.comments[data-answer-id="' + data.owner_id + '"]').append(JST["templates/comments/comment"](data))
  $('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML=''

$(document).on('turbolinks:load', comment_channel)