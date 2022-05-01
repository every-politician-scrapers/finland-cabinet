#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('.name').text.tidy
    end

    def position
      # Eurooppa- ja omistaja(-)ohjaus(-)ministeri has &shy hyphens
      # Ideally 'tidy' would get rid of these, or there's likely some
      # other better way, but for now just gsub them away.
      noko.css('.title').text.gsub(/\u00AD/, '').tidy
    end
  end

  class Members
    def member_container
      noko.css('.minister-tile')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
