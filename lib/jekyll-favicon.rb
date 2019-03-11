# rubocop:disable Naming/FileName
# rubocop:enable Naming/FileName
require 'jekyll'
require 'mini_magick'
require 'rexml/document'

require_relative 'jekyll/favicon/version'
require_relative 'jekyll/favicon'
require_relative 'jekyll/favicon/hooks'

require_relative 'jekyll/favicon/assets/files/includes/referenceable'
require_relative 'jekyll/favicon/assets/files/includes/sourceable'
require_relative 'jekyll/favicon/static_file'
require_relative 'jekyll/favicon/assets/data'
require_relative 'jekyll/favicon/assets/image'
require_relative 'jekyll/favicon/assets/markup'
require_relative 'jekyll/favicon/generator'
