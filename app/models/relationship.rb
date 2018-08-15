class Relationship < ApplicationRecord
  #belongs_to引数は_idを除く。デフォルトでは引数名のモデルを参照
  belongs_to :follower, class_name:'User'
  belongs_to :followed, class_name:'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
