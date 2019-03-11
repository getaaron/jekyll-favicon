Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::Favicon.build site
  Jekyll::Favicon.sources.each { |source| site.config['exclude'] << source }
end
