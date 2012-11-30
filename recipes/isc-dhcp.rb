module ::DHCP
  module Failover
    class << self
           def slaves
        []
      end

      def masters
        [@node]
      end

    end
  end
end

module ::DHCP
  module DynaDns 
    class  << self 
      def masters
        Hash.new 
      end
      def keys
        Hash.new 
      end

    end
  end
end

include_recipe "dhcp::server"