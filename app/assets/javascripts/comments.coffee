$ ->
  updateForm = (params) ->
    $('.edit-form form').attr("method", params.method)
    $('.edit-form form').attr("action", params.action)
    $('.bootsy_text_area')[0].name = params.bodyName

  $(document).on 'click', '#new-comment', () ->
    updateForm({
      method: "post",
      action: "/questions/#{this.dataset.questionId}/answers/#{this.dataset.answerId}/comment",
      bodyName: "comment[body]"
    })

  true