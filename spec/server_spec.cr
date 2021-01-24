require "../src/server"
require "spec"

struct TestServer
  struct UserMessage
    def initialize(@string : String)
    end
  end

  include CrystalByteProtocol::Server(self)
end

describe CrystalByteProtocol::Server do
  it "serializes" do
    serializer = TestServer.new
    object = TestServer::UserMessage.new "abc"
    serializer.serialize(object).should eq Bytes[0, 97, 98, 99, 0]
  end
end
