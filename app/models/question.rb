class Question < ActiveRecord::Base
	
	belongs_to :user
	has_many :answers
	has_many :questiontags
	has_many :tags, through: :questiontags
	has_many :votes

	scope :unanswered, lambda { joins(:answers).where(answers: { accepted: nil }) }
	scope :answered, lambda { joins(:answers).where(answers: { accepted: true }) }

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

		if self.answers.where(accepted: true).count > 0
			return true
		else
			return false
		end

	end

end
