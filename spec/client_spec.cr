require "../src/client"

enum TestEnum
  A = 0
  B = 0
  C = 1
  D = C
end

module TestClient
  extend CrystalByteProtocol::Client(self)

  record UserPing, msg : TestEnum

  record UserMessage, string : String
end

describe CrystalByteProtocol::Client do
  it "deserializes" do
    TestClient.deserialize?(Bytes[1, 97, 98, 99, 0]).should eq TestClient::UserMessage.new("abc")
  end
end
