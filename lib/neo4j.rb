# encoding: utf-8
module Belinkr
  module Persister
    module Neo4j
      ID_RE = /.*(?<id>\d+)$/
      attr_reader :id, :properties
      attr_accessor :node

      def self.included(caller)
        caller.class_eval { include InstanceMethods }
        caller.extend ClassMethods
      end

      module ClassMethods
        def connection
          @connection ||= Neography::Rest.new
        end

        def find(id)
          instance = self.new
          instance.node = connection.get_node(id)
          instance.properties = connection.get_node_properties(instance.node)
        end

        def create(args={})
          self.new(args).save
        end
      end

      module InstanceMethods
        def initialize(args={})
          @id = id_for(args["self"]) 
          self.properties = args
        end

        def properties=(args={})
          args.each { |k, v| instance_variable_set :"@#{k}", v }
          self
        end

        def attributes
          attr = {}
          instance_variables.each do |v|
            attr[v.to_s[1..-1].to_sym] = instance_variable_get v unless v.nil?
          end
          attr
        end

        def save
          self.node = create_node(attributes)
          self
        end

        def id_for(url)
          url.match(ID_RE)["id"].to_i if url
        end

        def update(args)
          self.properties = args
          self.save
        end

	      def destroy
          delete_node node
          self
	      end

        def method_missing(method, args)
          self.class.connection.send method
        end
      end # InstanceMethods
    end # Neo4j
  end # Persister
end # Belinkr
