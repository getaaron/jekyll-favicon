module Jekyll
  module Favicon
    module Assets
      module Properties
        # Add source reference to page or static file
        module Sourceable
          def self.included(_mod)
            attr_accessor :source
          end

          def sourceabilize(source, override_source, override_dir)
            @source = override_source || source
            @dir = override_dir || @dir || ''
          end

          def sourceable?
            File.file? path
          end

          def source_extname
            File.extname @source
          end

          def source_dir
            File.dirname @source
          end

          def source_name
            File.basename @source
          end

          def path
            File.join(*[@base, source_dir, source_name].compact)
          end

          def modified_time
            @modified_time ||= if File.file? path then File.stat(path).mtime
                               else Time.now
                               end
          end

          private

          def copy_file(dest_path)
            generate dest_path
          end
        end
      end
    end
  end
end
