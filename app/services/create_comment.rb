class CreateComment < ApplicationService
  attr_reader :commentable
  attr_reader :commenter

  def initialize(commenter, commentable, params)
    @commenter    = commenter
    @commentable  = commentable
    @params       = params
  end

  def comment
    @comment ||= Comment.new do |c|
      c.body        = form.body
      c.commentable = commentable
      c.commenter   = @commenter
    end
  end

  def form
    @form ||= CommentForm.new(@params.merge(loan: commentable).to_hash)
  end

  def perform
    return unless form.valid?

    comment.save
    @successful = comment.persisted?
  end
end
