require 'time'
require 'rack/utils'

module RSSFeed
  def self.render(locale:, t:, base_url:, items:)
    title       = t.dig('meta', 'title')       || 'Бульбашляндия'
    description = t.dig('meta', 'description') || ''
    now         = Time.now.utc.rfc2822
    self_url    = "#{base_url}/#{locale}/rss.xml"

    body = items.map do |item|
      <<~ITEM.chomp
        <item>
          <title>#{x(item[:title])}</title>
          <link>#{x(item[:link])}</link>
          <guid isPermaLink="true">#{x(item[:link])}</guid>
          <pubDate>#{(item[:date] || Time.now).utc.rfc2822}</pubDate>
          <description>#{x(item[:description])}</description>
          #{item[:category] ? "<category>#{x(item[:category])}</category>" : ''}
        </item>
      ITEM
    end.join("\n    ")

    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
        <channel>
          <title>#{x(title)}</title>
          <link>#{base_url}/#{locale}</link>
          <description>#{x(description)}</description>
          <language>#{locale}</language>
          <lastBuildDate>#{now}</lastBuildDate>
          <atom:link href="#{x(self_url)}" rel="self" type="application/rss+xml"/>
          #{body}
        </channel>
      </rss>
    XML
  end

  def self.x(str)
    Rack::Utils.escape_html(str.to_s)
  end
end