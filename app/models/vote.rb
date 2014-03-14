class Vote < ActiveRecord::Base
  belongs_to :question, touch: true
  belongs_to :user, touch: true
end
