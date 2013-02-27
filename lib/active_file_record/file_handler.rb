module ActiveFileRecord
  class FileHandler
    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def add_record(klass)
      entries = file_entries(filename) || []

      p entries

      entries << klass.attributes
      rewrite filename, entries
    end

    def select_all(relation)
      load(relation)
    end

    private
    def rewrite(filename, entries)
      File.open(entries_file(filename), "w") do |f|
        f.write(ActiveSupport::JSON.encode entries)
      end
    end

    def load(relation)
      result = []
      entries = file_entries relation.klass.filename

      if entries.is_a?(Array)
        entries.each do |entry|
          if check_entry(entry, relation.where_values)
            result << relation.klass.instantiate(entry)
          end
        end
      end

      p "Searchin in #{relation.klass.filename}"

      result
    end

    def check_entry(entry, where)
      suitable = true

      where.each do |condition|
        suitable &&= entry[condition.operand1.name.to_s].send(condition.operator, condition.operand2)
        return false if !suitable
      end

      true
    end

    def file_entries(filename)
      ActiveSupport::JSON.decode(File.read(entries_file filename))
    end

    def entries_file(filename)
      File.join(Rails.root, "records_storage", filename)
    end

  end
end