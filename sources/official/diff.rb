#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# Not listed on the site
SKIP = [
  ['---', 'Annika Saarikko', 'Suomen pääministerin sijainen']
].freeze

diff = EveryPoliticianScraper::Comparison.new('wikidata.csv', 'scraped.csv').diff
                                         .reject { |row| SKIP.include? row }

puts diff.sort_by { |r| [r.first, r.last.to_s] }.reverse.map(&:to_csv)
