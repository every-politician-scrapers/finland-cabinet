#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

# TODO: allow ScraperData to use Cabinet here!
class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.css('.name').text.tidy
    end

    field :position do
      noko.css('.title').text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      container.map { |member| fragment(member => Member).to_h }
    end

    private

    def container
      noko.css('.minister-tile')
    end
  end
end

url = 'https://valtioneuvosto.fi/marinin-hallitus/ministerit'
puts EveryPoliticianScraper::ScraperData.new(url).csv
