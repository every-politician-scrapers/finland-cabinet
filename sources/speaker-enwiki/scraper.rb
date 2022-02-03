#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def zeropad
    rjust(2, '0')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Image'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name img start end].freeze
    end

    def startDate
      raw_start.split('.').reverse.map(&:zeropad).join('-')
    end

    def endDate
      return if raw_end == 'Incumbent'

      raw_end.split('.').reverse.map(&:zeropad).join('-')
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
