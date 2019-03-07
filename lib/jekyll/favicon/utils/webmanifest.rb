# Build Webmanifest JSON
class Webmanifest
  attr_accessor :document

  def initialize(source, tree)
    input = File.exist?(source) ? JSON.parse(File.read(source)) : {}
    @document = Jekyll::Utils.deep_merge_hashes input, tree
  end

  def dump
    JSON.pretty_generate @document
  end

  def self.parse(config, options = {})
    return unless config.key? 'icons'
    {
      'icons' => [{
        'src' => options[:endpoint],
        'type' => options[:extname][1..-1],
        'sizes' => options[:sizes].join(' ')
      }]
    }
  end

  def self.output?(output)
    %w[.webmanifest .json].include? File.extname output
  end
end
