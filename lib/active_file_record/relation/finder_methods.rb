require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/indifferent_access'

module ActiveFileRecord
  module FinderMethods
    def find(*args)
      case args.first
      when :first, :last, :all
        send(args.first)
      else
        find_with_ids(*args)
      end
    end

    # A convenience wrapper for <tt>find(:first, *args)</tt>. You can pass in all the
    # same arguments to this method as you can to <tt>find(:first)</tt>.
    def first #(*args)
      #if args.any?
      #  if args.first.kind_of?(Integer) || (loaded? && !args.first.kind_of?(Hash))
      #    limit(*args).to_a
      #  else
      #    apply_finder_options(args.first).first
      #  end
      #else
        find_first
      #end
    end


    # A convenience wrapper for <tt>find(:last, *args)</tt>. You can pass in all the
    # same arguments to this method as you can to <tt>find(:last)</tt>.
    def last(*args)
        find_last
    end

    # A convenience wrapper for <tt>find(:all, *args)</tt>. You can pass in all the
    # same arguments to this method as you can to <tt>find(:all)</tt>.
    def all(*args)
      args.any? ? apply_finder_options(args.first).to_a : to_a
    end


    protected


    def find_with_ids(*ids)
      #ids = ids.flatten.compact.uniq

      case ids.size

      when 0
        raise RecordNotFound, "Couldn't find #{@klass.name} without an ID"
      when 1
        result = find_one(ids.first.to_i)
      end
    end

    def find_one(id)
      column = :id
      relation = where({primary_key=>{:eq => id}})
      record = relation.first

      unless record
        raise RecordNotFound , "Couldn't find #{@klass.name}"
      end

      record
    end

    def find_first
      if loaded?
        @records.first
      else
        @first ||= limit(1).to_a[0]
      end
    end

    def find_last
      if loaded?
        @records.last
      else
        to_a.last
        @last ||= to_a.last
      end
    end

  end
end
