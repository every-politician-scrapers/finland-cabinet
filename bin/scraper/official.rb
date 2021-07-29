#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.css('.name').text.tidy
    end

    field :position do
      # Eurooppa- ja omistaja(-)ohjaus(-)ministeri has &shy hyphens
      # Ideally 'tidy' would get rid of these, or there's likely some
      # other better way, but for now just gsub them away.
      noko.css('.title').text.gsub(/\u00AD/, '').tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
    end

    private

    def member_container
      noko.css('.minister-tile')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
