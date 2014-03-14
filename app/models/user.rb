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
  has_many :assessor_students, :class_name => "User", :foreign_key => "assessor_user_id"

  belongs_to :apprentice_coordinator, :class_name => "User", :foreign_key => "coordinator_user_id"
  has_many :coordinator_students, :class_name => "User", :foreign_key => "coordinator_user_id"

  has_many :notifications
  has_many :authored_notifications, :class_name => "Notification", :foreign_key => "author_id"

  belongs_to :employer, touch: true

  scope :admins, lambda { where("users.admin = true OR users.coordinator = true") }
  scope :coordinators, lambda { where("users.coordinator = true") }

  scope :has_knowledge, lambda {|tag_title| joins(:tags).where(:tags => { :title => tag_title }) }

  def last_seen_in_days
    time_ago_in_words(self.last_seen)
  end

  def friendly_start_date
    self.start_date.present? ? self.start_date.strftime("%d/%m/%Y") : ""
  end

  def friendly_end_date
    self.end_date.present? ? self.end_date.strftime("%d/%m/%Y") : ""
  end

  def is_admin

    User.admins.where(:id => self.id).exists?

  end

  def coordinator_id
    self.apprentice_coordinator != nil ? self.apprentice_coordinator.id : nil
  end

  def assessor_id
    self.assessor != nil ? self.assessor.id : nil
  end

  def employer_id
    self.employer != nil ? self.employer.id : nil
  end

  def full_name
    "#{self.forename} #{self.surname}"
  end

  #Notifies the assessor that a new user has signed up
  after_create :create_new_user_notification
  def create_new_user_notification
    
    #User.admins.notifications.create(:content => "has signed up", :author => self)

  end

end
