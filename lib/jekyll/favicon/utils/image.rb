# Build browserconfig XML
module Image
  def self.convert(input, output, options = {})
    case File.extname output
    when '.svg' then FileUtils.cp input, output
    when '.ico', '.png'
      MiniMagick::Tool::Convert.new do |convert|
        convert << input
        options_for convert, options if options
        convert << output
      end
    else raise ArgumentError
    end
  end

  def self.options_for(convert, options)
    convert.flatten
    basic_options convert, options
    resize_options convert, options
    odd_options convert, options
  end

  def self.basic_options(convert, options)
    convert.background options['background'] if options['background']
    if options['define']
      options['define'].each do |option, key_value|
        key, value = key_value.first
        convert.define "#{option}:#{key}=#{value}"
      end
    end
    convert.density options['density'] if options['density']
    convert.alpha options['alpha'] if options['alpha']
  end

  def self.resize_options(convert, options)
    convert.resize options['resize'] if options['resize']
  end

  def self.odd_options(convert, options)
    convert.gravity options['gravity'] if options['odd'] && options['gravity']
    convert.extent options['resize'] if options['odd'] && options['resize']
  end

  def self.input?(input)
    extname = File.extname input
    Jekyll::Favicon.defaults['processing']['input'].keys.include? extname
  end

  def self.output?(output)
    extname = File.extname output
    Jekyll::Favicon.defaults['processing']['output'].keys.include? extname
  end

  def self.parse(config, resource)
    output = {}
    processing_defaults = Jekyll::Favicon.defaults['processing']
    output.merge! update_input_processing processing_defaults, resource
    output.merge! update_ouput_processing processing_defaults, resource
    return unless config.key?('processing')
    output.merge! config['processing']
    if resource.sizes && resource.basename == '.ico'
      output['resize'] = resource.sizes.join ' '
    end
    output
  end

  def self.update_input_processing(configs, resource)
    return {} unless configs['input'].key? File.extname resource.source
    configs['input'][File.extname resource.source]
  end

  def self.update_ouput_processing(configs, resource)
    return {} unless configs['output'].key? resource.extname
    configs['output'][resource.extname]
  end
end
