module Cql::Model::PersistenceMethods
  extend ::ActiveSupport::Concern

  def save
    updates = []

    self.class.columns.each do |key, config|
      value = instance_variable_get("@#{config[:attribute_name].to_s}".to_sym)

      rv = "'#{value}'"
      unquoted = [Fixnum, Cql::Uuid, Float, Bignum]
      unquoted.each {|t| if value.is_a?(t) then rv = value  end}

      updates << "#{key.to_s} = #{rv}" unless value.nil?
    end

    updates = updates.join(', ')

    query = "UPDATE #{table_name} SET #{updates} WHERE #{primary_key} = #{quoted_primary_value}"
    Cql::Base.connection.execute(query)

    @persisted = true
    self
  end

  def deleted?
    @deleted
  end

  def delete
    query = "DELETE FROM #{table_name} WHERE #{primary_key} = #{quoted_primary_value}"
    Cql::Base.connection.execute(query)

    @deleted = true
    @persisted = false
    self
  end

  module ClassMethods

  end
end
