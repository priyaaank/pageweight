# Inspired from https://github.com/marks/RubyScriptPageLoad

require 'json'
require 'open-uri'

class PageWeight
  PHANTOMJS_BIN = `which phantomjs`.chop
  YSLOW_COMMAND = "./js/yslow.js --info all "

  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def calculate
    yslow_command = "#{PHANTOMJS_BIN} #{YSLOW_COMMAND} #{@url}"
    output = JSON.parse(`#{yslow_command}`)
    formatted output
  end

  private 

  def formatted yslow_output
    summary = "Complete page weight: #{yslow_output["w"].to_i/1024}kb"
    details = {}
    yslow_output["stats"].each do |type,stats|
      detail_listing = yslow_output["comps"].collect do |comp|
        next if comp["type"] != type
        "  - #{URI.decode(comp["url"])}: #{comp["size"]/1024}kb (#{comp["resp"]}ms response time)"
      end.compact
      details["+ #{type.upcase}: #{stats["w"].to_i/1024}kb (over #{stats["r"]} requests)\n"] = detail_listing
    end
    [summary, details]
  end
end

