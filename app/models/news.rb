include ActionView::Helpers::SanitizeHelper

require 'httparty'

class News
  #BBC top headlines from newsAPI
  BBC_url = "https://newsapi.org/v2/top-headlines?"\
	  	    "sources=bbc-news&"\
			"apiKey=#{Rails.application.secrets.news_api_key}"
  bbc_response = HTTParty.get(BBC_url)
  bbc_news_hash = bbc_response.parsed_response
  @@bbc_articles = bbc_news_hash['articles']

  #UCL Faculty of Engineering RSS feed
  Eng_url = "https://api.rss2json.com/v1/api.json?"\
  			"rss_url=http%3A%2F%2Fwww.engineering.ucl.ac.uk"\
			"%2Fnews-articles%2Ffeed%2F"
  eng_response = HTTParty.get(Eng_url)
  eng_news_hash = eng_response.parsed_response
  @@eng_articles = eng_news_hash['items']

  def self.news_list(news_feed)
	if news_feed == "BBC_feed"
	  articles = @@bbc_articles
	  title_field = "title"
	  content_field = "description"
	elsif news_feed == "engineering_feed"
	  articles = @@eng_articles
	  title_field = "title"
	  content_field = "content"
	end

    #insert mdash between news item title and news item content
    title_delimiter = "\u2014"

	news_list = Array.new
	articles.each do |article|
	  title = strip_tags(article["#{title_field}"])
	  content = strip_tags(article["#{content_field}"])
      news_list << "#{title}#{title_delimiter}#{content}"
    end
	news_list
  end

  def self.news_string(news_feed)
    #insert whitespace between news items
	item_delimiter = "\u2001" * 10

	news_string = ""
    self.news_list(news_feed).each_with_index do |item, index|
	  if index < (news_list(news_feed).size - 1)
	    news_string += "#{item}#{item_delimiter}"
	  else
	    news_string += "#{item}"
	  end
	end
	news_string
  end
end
