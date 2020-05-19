#!/usr/bin/env ruby
require 'optparse'
require 'yaml'
require 'uihex/version'

module UIHex
    class CONVERTER
        CONFIG_FILE_NAME = File.join(__dir__, '/config.yml')
        CONFIG = YAML.load_file(CONFIG_FILE_NAME)
    
        COMMANDS = { :CONVERT => "convert", :CONFIGURE => "config" }
    
        USES_FLOATING_POINTS = 'USES_FLOATING_POINTS'
        FLOATING_POINT_PRECISION = 'FLOATING_POINT_PRECISION'
        COPIES_TO_CLIPBOARD = 'COPIES_TO_CLIPBOARD'
    
        $options = {}
    
        OptionParser.new do |parser|
            parser.banner = "Usage: uihex <command> [options]"
            parser.separator  ""
            parser.separator  "Commands"
            parser.separator  "    uihex convert [HEX]: Converts HEX to RGB."
            parser.separator  "    uihex config: Persist default values."
            parser.separator  ""
            parser.separator  "Options"
    
            parser.on("-a", "--alpha [ALPHA]", Float, "Sets the alpha.") do |alpha|
                $options[:alpha] = alpha
            end
    
            parser.on("-c", "--copy [COPY]", TrueClass, "Copies the output to the clipboard.") do |copy|
                $options[:clipboard] = copy.nil? ? true : copy
            end
    
            parser.on("-f", "--floatingPoints [FLOATS]", TrueClass, "Uses floating points for the RGB values.") do |floats|
                $options[:floatingPoints] = floats.nil? ? true : floats
            end
    
            parser.on("-p", "--precision [PRECISION]", Integer, "Sets the floating point precision.") do |points|
                $options[:precision] = points
            end
    
            parser.on("-v", "--version", "The version of the script.") do
                puts UIHex::VERSION
                exit(0)
            end

            if ARGV.length == 0
                puts parser
                exit(0)
            end
        end.parse!
    
        def self.getConfigValueFrom(key)
            return CONFIG[key]
        end
    
        def self.setConfigValueFor(key, value)
            CONFIG[key] = value
            File.open(CONFIG_FILE_NAME,'w') do |c| 
            c.write CONFIG.to_yaml
            end
        end
    
        def self.validateAlphaRange(from, to)
            if $options.key?(:alpha) && from.is_a?(Float) && to.is_a?(Float)
                if $options[:alpha].is_a?(Float)
                    if !$options[:alpha].between?(from, to) 
                        STDERR.puts("Argument has to be in a range from " + from.to_s + " to " + to.to_s)
                        exit(false)
                    end
                end
            end
        end
    
        case ARGV.first
        when COMMANDS[:CONVERT]
            if $options.length == 0 && ARGV.length == 1
                exit(0)
            elsif ARGV[1]
                hex = ARGV[1].dup.to_s
                
                if hex.is_a?(String)
                    hex.delete! '#'
                end
            elsif ARGV[1] = ''
                    STDERR.puts("Put your HEX color between colons or remove the '#'")
                    exit(false)    
            end
    
            if hex =~ /^[0-9A-F]+$/i
                validateAlphaRange(0.0, 1.0)
    
                red     = hex[0..-5].to_i(16).to_s
                green   = hex[2..-3].to_i(16).to_s
                blue    = hex[4..5].to_i(16).to_s
                alpha   = $options[:alpha] ? $options[:alpha].to_s : "1.00"
            
                if $options.key?(:floatingPoints) ? $options[:floatingPoints] : getConfigValueFrom('USES_FLOATING_POINTS')
                    precision   = $options[:precision] || getConfigValueFrom('FLOATING_POINT_PRECISION')
                    red         = (red.to_f / 255).round(precision).to_s
                    green       = (green.to_f / 255).round(precision).to_s
                    blue        = (blue.to_f / 255).round(precision).to_s
                else
                    red += "/255"
                    green += "/255" 
                    blue += "/255"
                end
    
                uicolor = "UIColor(red: " + red + ", green: " + green + ", blue: " + blue + ", alpha: " + alpha + ")" 
                puts uicolor
    
                # Copies to clipboard and informs the user about it
                # Supports macOS
                if $options.key?(:clipboard) ? $options[:clipboard] : getConfigValueFrom('COPIES_TO_CLIPBOARD') 
                    IO.popen("pbcopy", "w") { |pipe| pipe.puts uicolor }
                    puts "Copied to clipboard ✨"
                end
    
                exit(0)
            else
                STDERR.puts("Argument is not a valid HEX color")
                exit(false)
            end
        when COMMANDS[:CONFIGURE]
            if $options.length == 0
                exit(0)
            end
            
            if $options.key?(:floatingPoints)
                setConfigValueFor('USES_FLOATING_POINTS', $options[:floatingPoints])
            end
    
            if $options.key?(:precision)
                setConfigValueFor('FLOATING_POINT_PRECISION', $options[:precision].nil? ? 2 : $options[:precision])
            end
    
            if $options.key?(:clipboard) 
                setConfigValueFor('COPIES_TO_CLIPBOARD', $options[:clipboard])
            end
    
            puts "Saved configuration to disc 💾"
            exit(0)
        end
    end
end

