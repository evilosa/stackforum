class AnswersChannel < ApplicationCable::Channel
  def follow_question_answers
    stop_all_streams
    stream_from "question_#{params[:id]}_answers"
  end

  def unfollow
    stop_all_streams
  end
end