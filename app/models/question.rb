class Question < ActiveRecord::Base
	
	belongs_to :user
	has_many :answers
	belongs_to :accepted_answer, :class_name => "Answer", :foreign_key => :answer_id

	has_many :questiontags
	has_many :tags, through: :questiontags
	has_many :votes

	validates :title, :presence => true
  	validates :content, :presence => true
  	validates :user, :presence => true

	scope :unanswered, lambda { where(answer_id: nil) }
	scope :answered, lambda { joins(:answers).where("answers.id = questions.answer_id") }

	def tag_list
		tags.map(&:title).join(", ")
	end

	def tag_list=(titles)
		self.tags = titles.split(",").map do |n|
    		Tag.where(title: n.strip).first_or_create do |t|
    			t.user = self.user
    		end 
  		end

  		self.tags.each do |ta|
  			if ta.count == nil
  				ta.count = 1
  			else
  				ta.count += 1
  			end
  			ta.save
  		end
	end

	def answered

		return self.accepted_answer != nil

	end

end
