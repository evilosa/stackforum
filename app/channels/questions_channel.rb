class QuestionsChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from 'questions'
  end

  def follow_question
    stop_all_streams
    stream_from "question_#{params[:id]}"
  end

  def unfollow
    stop_all_streams
  end
end