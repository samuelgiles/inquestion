class TagsController < ApplicationController

	def show

		@tag = Tag.find(params[:id])
		@number_of_questions_in_tag = Question.has_tag(@tag.title).count
		@last_question_update = Question.has_tag(@tag.title).select("questions.updated_at").order(:updated_at).first.try(:updated_at)
		@percent_answered = (Question.has_tag(@tag.title).answered.count.to_f / @number_of_questions_in_tag.to_f * 100).round(0)
		@number_of_knowledge_users = User.has_knowledge(@tag.title).count
		@questions = Question.has_tag(@tag.title).paginate(:page => params[:page], :per_page => 3)

		if params.has_key?(:new)
	      @sort_title = "New Questions"
	      @sort_title_short = "New"
	      @questions = Question.has_tag(@tag.title).order(:created_at).paginate(:page => params[:page], :per_page => 3)
	    elsif params.has_key?(:answered)
	      @sort_title = "Answered Questions"
	      @sort_title_short = "Answered"
	      @questions = Question.has_tag(@tag.title).answered.top_voted.order(:updated_at).paginate(:page => params[:page], :per_page => 3)
	    else
	      @sort_title = "Popular Questions"
	      @sort_title_short = "Popular"
	      @questions = Question.has_tag(@tag.title).top_voted.paginate(:page => params[:page], :per_page => 3)
	    end

	end

end
