$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra/base'
require 'yaml'
require 'active_support/all'
require 'padrino-helpers'
require 'lib/page_config'
require 'lib/site_utils'
require 'sass'
require 'compass'

class BrianDillard < Sinatra::Base
  include PageConfig

  register Padrino::Helpers

  helpers SiteUtils
  helpers PageConfig::TagHelpers

  # CONFIG

  set :erb, :layout => :"layouts/global"

  configure do
    set :scss, {
      :style => :expanded,
      :debug_info => true
    }

    Compass.add_project_configuration(
      File.join(File.dirname(__FILE__), 'config', 'compass.rb')
    )
  end

  # FILTERS

  before do
    @links = YAML::load(File.read('data/social_links.yml'))
    @nav_links = YAML::load(File.read('data/nav_links.yml'))
  end

  # ROUTES - ASSETS

  get '/css/compiled/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :"stylesheets/#{params[:name]}"
  end

  # ROUTES - CONTENT

  get '/' do
    @homepage = true
    @page.headline = "I help tech startups build great products."
    @page.title = ["Brian J. Dillard", "Chicago-based software craftsman"]
    @page.description = "I help tech startups build great products, sling Ruby and JavaScript code, obsess over Buffy & The Sandman & horror films, cover myself in tattoos, ride my bike around Chicago, hang out with my awesome husband, and try not to be one of the annoying vegans."
    @page.body_class = "home"

    erb :home
  end

  get '/bio' do
    @page.title = "Me, me, me"
    @page.body_class = "bio"

    erb :bio
  end

  get '/contact' do
    @page.title = "Getting in touch"
    @page.body_class = "contact"

    erb :contact
  end

  get '/guests' do
    @page.title = "Staying at 2710?"
    @page.body_class = "guests"

    erb :guests
  end

  get '/hire_me' do
    @page.title = "How to hire me"
    @page.body_class = "hire_me"

    erb :hire_me
  end

  get '/links' do
    @page.title = "My favorite reads"
    @page.body_class = "links"

    erb :links
  end

  get '/projects' do
    @page.title = "Me around the web"
    @page.body_class = "projects"

    erb :projects
  end

  get '/resume' do
    @page.headline = "Brian J. Dillard"
    @page.subhead = "I help tech startups build great products."
    @page.body_class = "resume"
    @page.suppress :logline

    erb :resume
  end

  get '/software' do
    @page.headline = "My favorite software"
    @page.subhead = "What I use to get things done"
    @page.body_class = "software"

    erb :software
  end

  get '/tattoo' do
    @page.title = "My sweet tattoos"
    @page.body_class = "tattoo"

    erb :tattoo
  end

  not_found do
    @page.headline = 'Oops ...'
    @page.subhead = 'Bad link or user error?'
    @page.body_class = "error"
    status 404

    erb :"404"
  end

  error do
    @page.headline = 'Oops ...'
    @page.subhead = 'My code broke!'
    @page.body_class = "error"
    status 500

    erb :error
  end
end
