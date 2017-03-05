class CommentsChannel < ApplicationCable::Channel
  def follow_question_comments
    stop_all_streams
    stream_from "question_#{params[:id]}_comments"
  end

  def unfollow
    stop_all_streams
  end
end