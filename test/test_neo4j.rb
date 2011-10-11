# encoding: utf-8
require "minitest/autorun"
require "neography"
require_relative "../lib/neo4j"

class Friend
  include Belinkr::Persister::Neo4j
end

describe "#connection" do
  it "returns current connection to neo4j" do
    Friend.new.class.connection.class.must_equal Neography::Rest
  end
end

describe "#find" do
  it "gets a node by its ID" do
    node = Friend.new(name: "Lorenzo").save
    node.id.must_be_same_as Friend.find(node.id).id
  end

  it "returns nil if not found" do
    Friend.find(54783).must_be_nil
  end
end

describe "#create" do
  it "creates a node a returns its ID" do
    friend = Friend.create
    friend.id.class.must_equal Fixnum
  end
end

describe "#new" do
  it "returns a new node" do
    Friend.new.respond_to?(:id).must_equal true
  end
end

describe "#attributes" do
  it "returns a hash with instance variables and their values" do
    friend = Friend.new(name: "Lorenzo")
    friend.attributes.keys.include?(:name).must_equal true
  end
end

describe "#properties" do
  it "gets saved properties" do
    friend = Friend.new(name: "Lorenzo")
    friend.save
  end
end

describe "#save" do
  it "saves a node a returns its ID" do
    friend = Friend.new.save
    friend.id.class.must_equal Fixnum
  end
end

describe "#update" do
  it "updates the properties of an existing node" do
    friend = Friend.create(name: "Lorenzo")
    friend.update(name: "Wen Bo")
    #friend.properties["name"].must_equal "Wen Bo"
  end
end

describe "#destroy" do
  before do 
    @new_friend = Friend.create(name: "wenbo")
    @id = @new_friend.id
  end

  it "destroys the node" do
    destroyed_friend = @new_friend.destroy
    Friend.find(@id).must_equal nil
  end

  it "returns self" do
    deleted_friend = @new_friend.destroy
    deleted_friend.must_be_instance_of Friend
  end
end
