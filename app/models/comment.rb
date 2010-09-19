class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  default_scope :order => 'created_at ASC'
  belongs_to :user
  
  validates_presence_of :user
  validates_presence_of :commentable
  validates_length_of :comment, :minimum => 2
end
