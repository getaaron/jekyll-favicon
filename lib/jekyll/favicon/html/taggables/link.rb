## HTML link tag abstraction
class Link < Taggable
  attr_accessor :crossorigin, :href, :hreflang, :media, :rel, :sizes, :type

  def initialize(resource, customs = {})
    attributes = Jekyll::Favicon.defaults['tags']['link'][resource.extname]
    attributes.merge(customs).each do |k, v|
      instance_variable_set("@#{k}", v)
    end
    @href = resource.endpoint
    @sizes = resource.sizes.join ' ' if sizes_must_be_updated?
  end

  def sizes_must_be_updated?
    ['auto', true].include?(@sizes)
  end

  def path_is_root?
    roots = ['', '/']
    roots.include? File.dirname @href
  end

  def skip?
    case @skip
    when [true, false] then @skip
    when 'root' then path_is_root?
    else false
    end
  end
end
