require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css("div.student-card a").each do |student|
        student_profile_link = student.attr("href")
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end


  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    profile = {}
    social_icon_links = profile_page.css(".social-icon-container a")

    social_icon_links.each do |link|
      link_text = link.attr("href")
      
      if link_text.include?("linkedin")
        profile[:linkedin] = link_text
      elsif link_text.include?("twitter")
        profile[:twitter] = link_text
      elsif link_text.include?("github")
        profile[:github] = link_text
      else
        profile[:blog] = link_text
      end
    end

    profile[:profile_quote] = profile_page.css("div.profile-quote").text
    profile[:bio] = profile_page.css("div.description-holder p").text
    profile
  end

end

