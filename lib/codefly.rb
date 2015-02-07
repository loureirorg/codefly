require "codefly/version"

# we need to hack ActiveRecord to read :connection variable from the thread
module ActiveRecord
  module ConnectionAdapters
    class ConnectionHandler
      def retrieve_connection(klass) #:nodoc:
        pool = retrieve_connection_pool(klass)
        raise ConnectionNotEstablished, "No connection pool for #{klass}" unless pool
        conn = if Thread.current[:connection].blank?
          pool.connection
        else
          if Thread.current[:connection] == :new
            ActiveRecord::Base.connection_pool.checkout()
          else
            Thread.current[:connection]
          end
        end
        raise ConnectionNotEstablished, "No connection for #{klass} in connection pool" unless conn
        conn
      end
    end
  end
end

@fly_thrs = {}

def fly(id)
  return unless block_given?
  raise 'ID already in use' if @fly_thrs.has_key? id
  @fly_thrs[id] = Thread.new do
    Thread.current[:connection] = :new
    yield
    ActiveRecord::Base.connection_pool.checkin(Thread.current[:connection]) if Thread.current[:connection] != :new
  end
end

def wait_fly(*ids)
  ids.each do |id|
    if @fly_thrs[id].present?
      begin
      @fly_thrs[id].value # wait until ends
      ensure
      @fly_thrs.delete(id) # remove from threads pool
      end
    end
  end
end
  
# module CodeFly
# end