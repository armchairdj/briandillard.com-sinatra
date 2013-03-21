if defined?(BrianDillard)
  # This is the configuration to use when running within sinatra
  project_path = BrianDillard.root
  environment = :development
else
  # this is the configuration to use when running within the compass command line tool.
  css_dir = File.join 'public', 'css', 'compiled'
  relative_assets = true
  environment = :production
end

# This is common configuration
sass_dir = File.join 'stylesheets'
images_dir = File.join 'public', 'img'
http_path = "/"
http_images_path = "/images"
http_stylesheets_path = "/stylesheets"