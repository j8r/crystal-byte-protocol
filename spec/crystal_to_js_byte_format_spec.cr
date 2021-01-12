require "./server_spec"
require "./client_spec"
require "../src/crystal_to_js_byte_format"

describe CrystalByteProtocol::CrystalToJS do
  it "converts to JS files" do
    CrystalByteProtocol::CrystalToJS.convert_to_file(
      File::NULL,
      TestClient
    )

    CrystalByteProtocol::CrystalToJS.convert_to_file(
      File::NULL,
      TestServer
    )
  end
end
