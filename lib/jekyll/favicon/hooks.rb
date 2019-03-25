require 'jekyll/hooks'

Jekyll::Hooks.register :site, :after_init do |site|
  favicon_sources = Jekyll::Favicon.sources site
  site.config['exclude'].push(*favicon_sources)
end
