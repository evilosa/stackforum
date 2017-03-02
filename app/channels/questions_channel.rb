class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions'
  end

  def follow_question
    stream_from "question_#{params[:id]}"
  end
end