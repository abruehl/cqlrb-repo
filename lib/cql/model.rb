require 'active_model'

require 'active_support/concern'
require 'active_support/core_ext'

require 'cql/base'
require 'cql/model/version'

require 'cql/model/schema_methods'
require 'cql/model/finder_methods'
require 'cql/model/persistence_methods'
require 'cql/model/query_result'

require 'uuidtools'

module Cql
  class Model
    extend ActiveModel::Naming

    #include ActiveModel::AttributeMethods
    #include ActiveModel::Callbacks
    include ActiveModel::Conversion
    include ActiveModel::Dirty
    #include ActiveModel::Observing
    include ActiveModel::Serialization
    #include ActiveModel::Translation
    include ActiveModel::Validations

    include Cql::Model::SchemaMethods
    include Cql::Model::FinderMethods
    include Cql::Model::PersistenceMethods

    attr_reader :primary_value

    def initialize(attributes = {}, options = {})
      self.class.columns.each do |key, config|
        class_eval do
          attr_reader config[:attribute_name]
          attr_writer config[:attribute_name] unless config[:read_only]
        end
      end
      pk_settings = self.class.pk_settings
      class_eval do
        attr_reader self.primary_key.to_sym
        alias  :primary_value :"#{self.primary_key}"
        unless pk_settings[:read_only] == true
          attr_writer self.primary_key.to_sym
          alias  :primary_value= :"#{self.primary_key}="
        end
      end

      @metadata = options[:metadata]
      @persisted = false
      @deleted = false

      attributes.each do |key, value|
        attr_name = "@#{key.to_s}".to_sym
        instance_variable_set(attr_name, value)
      end

      if pk_settings[:auto_uuid] && primary_value.nil?
        self.instance_variable_set("@#{self.primary_key}", Cql::Uuid.new(UUIDTools::UUID.random_create.to_s))
      end

      self
    end

    def quoted_primary_value
      rv = "'#{primary_value}'"
      unquoted = [Fixnum, Cql::Uuid, Float, Bignum]
      unquoted.each {|t| if primary_value.is_a?(t) then rv = primary_value  end}
      rv
    end

    def persisted?
      @persisted
    end

    def self.execute(query)
      cql_results = Cql::Base.connection.execute(query, consistency)
      Cql::Model::QueryResult.new(cql_results, self)
    end
  end
end
