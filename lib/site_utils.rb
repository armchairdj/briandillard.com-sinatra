module SiteUtils

  def render_partial(template, *args)
    options = args.extract_options!
    options.merge!(:layout => false)

    full_template = :"partials/#{template}"

    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << erb(full_template, options.merge(
          :layout => false, 
          :locals => {
            template.to_sym => member
          }
        ))
      end.join("\n")
    else
      erb(full_template, options)
    end
  end

  def home_link(content, attrs = nil)
    attrs ||= {}
    attrs[:title] = 'back to the homepage'

    link_to(content, "/", attrs)
  end

  def logo
    text = '<img src="/img/honeymoon.jpg" alt="Brian J. Dillard" />'

    return text if @homepage

    home_link text, { :class => 'mugshot' }
  end
end
