require "../src/server"
require "spec"

struct TestServer
  record UserPing, msg : TestEnum

  record UserMessage, string : String

  include CrystalByteProtocol::Server(self)
end

describe CrystalByteProtocol::Server do
  it "serializes" do
    serializer = TestServer.new
    object = TestServer::UserMessage.new "abc"
    serializer.serialize(object).should eq Bytes[1, 97, 98, 99, 0]
  end
end
