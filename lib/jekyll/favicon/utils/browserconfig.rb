require 'rexml/document'

# Build browserconfig XML
class Browserconfig
  attr_accessor :document

  def initialize(source, tree)
    input = File.read source if File.file? source
    @document = REXML::Document.new input
    deep_populate @document, tree
  end

  def dump
    output = ''
    formatter = REXML::Formatters::Pretty.new 2
    formatter.compact = true
    formatter.write @document, output
    output
  end

  def self.parse(config, options = {})
    return unless config
    if config['msapplication'] && config['msapplication']['tile']
      config['msapplication']['tile'].each do |key, _|
        if config['msapplication']['tile'][key]['_src']
          config['msapplication']['tile'][key]['_src'] = options[:endpoint]
        end
      end
    end
    { 'browserconfig' => config }
  end

  def self.output?(output)
    %w[.xml].include? File.extname output
  end

  private

  def deep_populate(parent, tree)
    parent.add_text tree and return if tree.is_a? String
    tree.each do |name, subtree|
      parent.add_attribute name[1..-1], subtree and next if name.start_with? '_'
      parent.elements[name] ||= REXML::Element.new name
      deep_populate parent.elements[name], subtree
    end
  end
end
