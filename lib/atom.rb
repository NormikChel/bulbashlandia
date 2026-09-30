require 'time'
require 'rack/utils'

module AtomFeed
  def self.render(locale:, t:, base_url:, items:)
    title       = t.dig('meta', 'title')       || 'Бульбашляндия'
    description = t.dig('meta', 'description') || ''
    updated     = Time.now.utc.iso8601
    self_url    = "#{base_url}/#{locale}/atom.xml"

    entries = items.map do |item|
      <<~ENTRY.chomp
        <entry>
          <title>#{x(item[:title])}</title>
          <link href="#{x(item[:link])}" rel="alternate" type="text/html"/>
          <id>#{x(item[:link])}</id>
          <updated>#{(item[:date] || Time.now).utc.iso8601}</updated>
          <summary>#{x(item[:description])}</summary>
          #{item[:category] ? %(<category term="#{x(item[:category])}"/>) : ''}
        </entry>
      ENTRY
    end.join("\n  ")

    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom" xml:lang="#{locale}">
        <title>#{x(title)}</title>
        <subtitle>#{x(description)}</subtitle>
        <link href="#{base_url}/#{locale}" rel="alternate" type="text/html"/>
        <link href="#{x(self_url)}" rel="self" type="application/atom+xml"/>
        <id>#{x(self_url)}</id>
        <updated>#{updated}</updated>
        <author><name>#{x(title)}</name></author>
        #{entries}
      </feed>
    XML
  end

  def self.x(str)
    Rack::Utils.escape_html(str.to_s)
  end
end