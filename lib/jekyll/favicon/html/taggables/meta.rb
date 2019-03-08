# HTML meta tag abstraction
class Meta < Taggable
  attr_accessor :charset, :content, :http_equiv, :name

  def initialize(resource, custom_attributes = {})
    attributes = Jekyll::Favicon.defaults['tags']['meta']
    attributes.merge(custom_attributes).each do |attribute, value|
      variable = attribute.sub('-', '_')
      value = resource.endpoint if value == resource.basename
      instance_variable_set("@#{variable}", value)
    end
  end

  def skip?
    !name || !content || content.eql?('auto')
  end
end
