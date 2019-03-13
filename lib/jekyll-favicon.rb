# rubocop:disable Naming/FileName
# rubocop:enable Naming/FileName
require 'jekyll'
require 'mini_magick'
require 'rexml/document'

require_relative 'jekyll/favicon/version'
require_relative 'jekyll/favicon/utils'
require_relative 'jekyll/favicon'

require_relative 'jekyll/favicon/assets/properties/referenceable'
require_relative 'jekyll/favicon/assets/properties/convertible'
require_relative 'jekyll/favicon/assets/properties/mappeable'
require_relative 'jekyll/favicon/assets/properties/sourceable'
require_relative 'jekyll/favicon/static_file'
require_relative 'jekyll/favicon/assets/data'
require_relative 'jekyll/favicon/assets/image'
require_relative 'jekyll/favicon/assets/markup'
require_relative 'jekyll/favicon/generator'

require_relative 'jekyll/favicon/hooks'

# require_relative 'jekyll/favicon/assets/tags/tag'
# require_relative 'jekyll/favicon/assets/tags/link'
# require_relative 'jekyll/favicon/assets/tags/meta'
# require_relative 'jekyll/favicon/assets/tags/includes/taggable'
# require_relative 'jekyll/favicon/tag'
