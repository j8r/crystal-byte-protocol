require "./server_spec"
require "./client_spec"
require "../src/crystal_to_js_byte_format"

private struct Test
  @io = IO::Memory.new
end

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

  describe "convert" do
    it "raises on unsupported type" do
      expect_raises CrystalByteProtocol::CrystalToJS::Error do
        CrystalByteProtocol::CrystalToJS.convert IO::Memory.new, Test, :client
      end
      expect_raises CrystalByteProtocol::CrystalToJS::Error do
        CrystalByteProtocol::CrystalToJS.convert IO::Memory.new, Test, :server
      end
    end

    describe "an enum" do
      it "client" do
        str = String.build do |str|
          CrystalByteProtocol::CrystalToJS.convert_all str, TestClient, :client
        end
        str.should contain <<-E
        Object.freeze({
          A: 0,
          B: 0,
          C: 1,
          D: 1,
        })
        E
      end

      it "server" do
        str = String.build do |str|
          CrystalByteProtocol::CrystalToJS.convert_all str, TestClient, :server
        end
        str.should contain <<-E
        Object.freeze({
          0: "A",
          0: "B",
          1: "C",
          1: "D",
        })
        E
      end
    end
  end
end
