#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

require 'open-uri/cached'

# There are lots of blank images messing up the layout,
# so just rmeove any image link
class RemoveDateExtras < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('td small').remove
    end.to_s
  end
end


class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator RemoveDateExtras
  # decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'virassa'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name dates].freeze
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
