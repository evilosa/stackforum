class CommentPresenter
  def initialize(comment)
    @comment = comment
    @owner = comment.commentable
  end

  def as(presence)
    send("present_as_#{presence}")
  end

  def present_as_publish
    {
      action: action,
      owner_id: @owner.id,
      question_id: question_id,
      comment: @comment,
      comment_email: @comment.user.email
    }
  end

  private

  def action
    case @owner
     when Question then
       'create_question_comment'
     when Answer then
       'create_answer_comment'
     else
       'create_comment'
   end
  end

  def question_id
    case @owner
     when Question then @owner.id
     when Answer then @owner.question_id
    end
  end
end