require "../src/client"

module TestClient
  extend CrystalByteProtocol::Client(self)

  record UserMessage, string : String { }
end

describe CrystalByteProtocol::Client do
  it "deserializes" do
    TestClient.deserialize?(Bytes[0, 97, 98, 99, 0]).should eq TestClient::UserMessage.new("abc")
  end
end
