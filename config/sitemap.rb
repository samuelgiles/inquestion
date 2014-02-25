# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://inquestion.co.uk"

SitemapGenerator::Sitemap.create do

  #about
  add about_page_path, :priority => 0.9, :changefreq => 'monthly'
  #terms
  add terms_page_path, :priority => 0.3, :changefreq => 'yearly'
  #privacy
  add privacy_page_path, :priority => 0.3, :changefreq => 'yearly'

  #signup
  add new_user_registration_path, :priority => 0.6, :changefreq => 'yearly'
  #signin
  add new_user_session_path, :priority => 0.6, :changefreq => 'yearly'

  #questions index
  add questions_path, :priority => 0.8, :changefreq => 'daily'

  #questions:
  Question.find_each do |question|
    add question_path(question), :priority => 0.5, :lastmod => question.updated_at
  end

  #tags:
  Tag.find_each do |tag|
    add tag_path(tag), :priority => 0.4, :lastmod => tag.updated_at
  end

end
