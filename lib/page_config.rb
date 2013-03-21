require 'active_support/all'

module PageConfig

  def self.included(base)
    base.class_eval do
      before do
        @page ||= PageConfig::ConfigStore.new(settings)
      end
    end
  end

  class ConfigStore
    SITE_NAME = 'briandillard.com'
    DEFAULT_DESCRIPTION = 'The personal website of Brian J. Dillard, a software engineer in Chicago, IL, USA'
    DEFAULT_KEYWORDS = 'JavaScript, Ruby, Rails, Ruby on Rails, Sinatra, jQuery, Ajax, programmer, web developer, responsive design, progressive enhancement, HTML, HTML5, CSS, CSS3, tattoos, comix, comics, Chicago, armchairdj, Buffy the Vampire Slayer, The Sandman, Brian Dillard'
    DEFAULT_VIEWPORT = 'width = device-width, initial-scale = 1.0'
    DEFAULT_AUTHOR = "Brian J. Dillard"
    START_YEAR = "2013"

    SEPARATOR = " / "

    attr_accessor :body_class
    attr_accessor :title
    attr_accessor :headline
    attr_accessor :subhead
    attr_accessor :description
    attr_accessor :keywords
    attr_accessor :author
    attr_accessor :viewport
    attr_accessor :noindex
    attr_accessor :nofollow
    attr_accessor :canonical_url

    attr_reader :env

    def initialize(settings, *args)
      @settings = settings
      @description = DEFAULT_DESCRIPTION
      @keywords = DEFAULT_KEYWORDS
      @author = DEFAULT_AUTHOR
      @viewport = DEFAULT_VIEWPORT
      @suppressed = []
      @noindex = false
      @nofollow = false

      @env = settings.environment.to_s.first(3).upcase
      
      if @env == "PRO"
        @env = nil
        @collect_analytics = true
      else
        @collect_analtyics = false
      end
    end

    def copyright_years
      start = START_YEAR
      now = Time.now.strftime '%Y'
      daterange = start
      daterange << "-#{now}" unless start == now

      daterange
    end

    def collect_analytics?
      @collect_analytics
    end

    def content_headline
      @headline || @title
    end

    def content_title
      @title || @headline
    end

    def html_title
      tokens = array_from(content_title || DEFAULT_DESCRIPTION)

      tokens << SITE_NAME
      tokens << @env

      tokens.delete_if { |t| t.blank? }.join(SEPARATOR)
    end

    def suppress(*args)
      @suppressed.push(*args.map { |part| part.to_sym })
    end

    def suppressed?(part)
      @suppressed.include? part.to_sym
    end

    private

    def array_from(source = nil)
      return [] unless source

      source.is_a?(String) ? [source] : source
    end

  end

  module TagHelpers
    def header_tag
      return unless headline = @page.content_headline

      markup = [content_tag(:h1, headline)]

      markup.push(content_tag(:h2, @page.subhead)) unless @page.subhead.blank?

      content_tag(:header, markup.join, class: "pageHeader")
    end

    def title_tag
      content_tag(:title, @page.html_title)
    end

    def seo_tags
      tags = [ "",
        content_type_meta_tag,
        description_meta_tag,
        keywords_meta_tag,
        author_meta_tag,
        viewport_meta_tag,
        robots_meta_tag,
        canonical_link_tag
      ].delete_if { |tag| tag.blank? }

      tags.join( "\n" )
    end

    def content_type_meta_tag
      meta_tag 'text/html; charset=UTF-8', 'http-equiv' => 'Content-Type'
    end

    def description_meta_tag
      meta_tag @page.description, name: 'description'
    end

    def keywords_meta_tag
      meta_tag @page.keywords, name: 'keywords'
    end

    def author_meta_tag
      meta_tag @page.author, name: 'author'
    end

    def viewport_meta_tag
      meta_tag @page.viewport, name: 'viewport'
    end

    def robots_meta_tag
      return unless @page.noindex || @page.nofollow

      meta_tag "#{'no' if @page.noindex}index,#{'no' if @page.nofollow}follow", name: 'robots'
    end

    def canonical_link_tag
      return unless @page.canonical_url

      tag(:link, {
        :rel => 'canonical',
        :href => @page.canonical_url
      })
    end

    def body_attrs
      attrs = {}

      if className = @page.body_class
        attrs[:class] = className
      end

      attrs
    end

    def copyright_notice
      "<span>Copyright &copy; #{@page.copyright_years} #{@page.author}.</span>"
    end
  end

end