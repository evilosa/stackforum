class AnswersChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from 'answers'
  end

  def follow_answer
    stop_all_streams
    stream_from "answer_#{params[:id]}"
  end

  def unfollow
    stop_all_streams
  end
end