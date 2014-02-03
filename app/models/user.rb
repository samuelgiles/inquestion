class User < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lastseenable
  has_many :questions
  has_many :answers
  has_many :tags, :foreign_key => 'user_id', :class_name => "Tag", :through => :notifytags
  has_many :notifytags
  belongs_to :assessor, :class_name => "User", :foreign_key => "assessor_user_id"
  has_many :students, :class_name => "User", :foreign_key => "assessor_user_id"

  has_many :notifications
  has_many :authored_notifications, :class_name => "Notification", :foreign_key => "author_id"

  scope :admins, lambda { where(admin: true) }

  def last_seen_in_days
    time_ago_in_words(self.last_seen)
  end

  def full_name
    "#{self.forename} #{self.surname}"
  end

  #Notifies admins of new user sign ups
  after_create :create_new_user_notification
  def create_new_user_notification
    
    admins = User.admins
    admins.each do |admin|

      admin.notifications.create(:content => "has signed up", :author => self)

    end

  end

end
