class AnswerPresenter
  def initialize(answer)
    @answer = answer
    @question = answer.question
  end

  def as(presence)
    send("present_as_#{presence}")
  end

  def present_as_publish
    {
        action: 'create_answer',
        answer: @answer,
        answer_score: @answer.score,
        attachments: attachments,
        question: @question,
        email: @answer.user.email
    }
  end

  private

  def attachments
    attachments = []
    @answer.attachments.each { |a| attachments << { id: a.id, name: a.file.identifier, url: a.file.url } }
    attachments
  end
end