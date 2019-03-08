# Static file or document component
class Resource
  attr_accessor :site, :source, :path, :basename
  attr_accessor :sizes, :tags, :processing, :references

  def initialize(site, source, path, basename, customs = {})
    @site = site
    @path = path
    (@source = source if Jekyll::Favicon.input? source) or raise ArgumentError
    extract_attributes_from basename
    overwrite_attributes_with customs
    return if unprocessable?
    @tags = generate_tags_from customs
    @processing = Image.parse customs, self
    @references = parse_references_in customs
  end

  def unprocessable?
    processables = case File.extname @source
                   when '.svg' then %w[.svg .ico .png .xml .webmanifest .json]
                   when '.png' then %w[.ico .png .xml .webmanifest .json]
                   when '.xml' then %w[.xml]
                   when '.webmanifest', '.json' then %w[.webmanifest .json]
                   else []
                   end
    !processables.include? extname
  end

  def extname
    File.extname @basename
  end

  def endpoint
    File.join(*[(@site.baseurl || ''), @path, @basename].compact)
  end

  def dirname
    File.join(*[@site.baseurl, @path].compact)
  end

  def metas
    return [] unless @tags
    @tags.select { |tag| tag.is_a? Meta }
  end

  def links
    return [] unless @tags
    @tags.select { |tag| tag.is_a? Link }
  end

  def input
    File.join @site.source, @source
  end

  def process(input, output)
    referencess = Jekyll::Favicon.references @site
    case extname
    when '.svg', '.png', '.ico' then Image.convert input, output, @processing
    when '.xml' then Browserconfig.new(input, referencess[:browserconfig]).dump
    when '.webmanifest', '.json'
      Webmanifest.new(input, referencess[:webmanifest]).dump
    end
  end

  private

  def extract_attributes_from(basename)
    raise ArgumentError unless Jekyll::Favicon.output? basename
    @basename = basename
    size = basename[/.*-(\d+x\d+).[a-zA-Z]+/, 1] if basename.respond_to? :match
    @sizes = [size] if size
  end

  def overwrite_attributes_with(customs)
    %w[path sizes source].each do |attribute|
      if customs.key?(attribute)
        instance_variable_set "@#{attribute}", customs[attribute]
      end
    end
    raise ArgumentError unless Jekyll::Favicon.input? @source
  end

  def generate_tags_from(customs)
    [Meta, Link].collect do |klass|
      klass.build self, customs, ensure_link?
    end.flatten.compact
  end

  def ensure_link?
    %w[.svg .ico .png .webmanifest .json].include? extname
  end

  def parse_references_in(customs)
    references = {}
    return references unless customs.key? 'references'
    if (config = customs['references']['webmanifest'])
      references[:webmanifest] = Webmanifest.parse config, endpoint: endpoint,
                                                           extname: extname,
                                                           sizes: sizes
    end
    return references unless (config = customs['references']['browserconfig'])
    references[:browserconfig] = Browserconfig.parse config, endpoint: endpoint
    references
  end
end
