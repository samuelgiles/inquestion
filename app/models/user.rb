class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers
  has_many :tags, :foreign_key => 'user_id', :class_name => "Tag", :through => :notifytags
  has_many :notifytags
  belongs_to :assessor, :class_name => "User", :foreign_key => "assessor_user_id"
  has_many :students, :class_name => "User", :foreign_key => "assessor_user_id"
end
