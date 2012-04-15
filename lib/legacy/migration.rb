# Encoding: utf-8
require 'dbf'
require 'seed-fu'

module Legacy
  class Migration

    # @return [DBF::Table]

    attr_reader :legacy_table

    # Modelo de la aplicación al cual se migran los datos.
    # @return [constant]

    attr_reader :model

    # Inicializa la migración
    #
    # @param [Hash] opts Datos de inicialización.
    # @option opts [String] :legacy_table Archivo dbf de donde obtener los datos
    # @option opts [Constant] :model Modelo donde guardar los datos.
    # @option opts [Bool] :verbose (false) be verbose.

    def initialize(opts)
      @legacy_table = DBF::Table.new("db/legacy/#{opts[:legacy]}")
      @model = opts[:model]
      SeedFu.quiet = true unless opts.delete(:verbose)
    end

    # Corre la migración
    #
    # @option opts [:all, Fixnum] :count (:all) cantidad de datos a migrar (:all
    #   para migrar todos los registros).

    def run(opts = {})
      count = opts[:count] || :all
      if count.kind_of? Integer
        count.times do |i|
          record = @legacy_table.find(i)
          migrate_record(record) if record
        end
      else
        @legacy_table.each do |record|
          migrate_record(record) if record
        end
      end
    end

    # Cierra el archivo dbf.
    #
    # @return [Bool]

    def close
      @legacy_table.close
    end

    private

    def migrate_record(record)
      attributes = clean_duplicated_attributes record.attributes
      @model.seed(attributes)
    end

    def clean_duplicated_attributes(attributes)
      attributes.select { |k,v| k =~ /^[a-z]*$/ }
    end

  end
end

