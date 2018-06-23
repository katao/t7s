module T7s
  class Idol
    attr_reader :idol_id, :key, :name
    @@config = nil
    @@all_idols = nil

    def initialize(**args)
      @idol_id          = args[:idol_id]
      @key              = args[:key]
      @name             = Name.new(args[:name])
    end
    alias_method :id, :idol_id

  class << self
    def config
      unless @@config
        @@config = Dir.glob("#{File.dirname(__FILE__)}/../../config/idols/*.yml").each_with_object({}) do |file, idols|
          idols.merge!(YAML.load_file(file))
        end.deep_symbolize_keys
        @@all_idols = nil
      end
      @@config
    end


    def names
      config.keys
    end

    def all
      @@all_idols ||= config.map { |key, prof| prof[:key] = key; new(prof) }.sort_by { |idol| idol.id }
    end
    alias_method :all_idols, :all

    def find(idol_id)
      all_idols.find { |idol| idol.id == idol_id }
    end
    alias_method :find_by_id, :find

    def find_by_name(idol_name)
      all_idols.find { |idol| [idol.key, idol.name].include?(idol_name) } || (raise UnknownIdolError, "unknown idol: #{idol_name}")
    end

    def valid?(idol_name)
      names.include?(idol_name)
    end
    end

    class UnknownIdolError < StandardError; end
  end
end
