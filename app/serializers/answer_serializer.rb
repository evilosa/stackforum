class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :comments, serializer: CommentSerializer
  has_many :attachments, serializer: AttachmentSerializer
end
