require "log"
require "crystalizer/byte_format"

module CrystalByteProtocol::Server(S)
  property log : Log = Log.for("crystal-byte-protocol.serializer")

  private struct SerializerInstance
    getter buffer : IO::Memory = IO::Memory.new
    getter byte_format : Crystalizer::ByteFormat

    def initialize
      @byte_format = Crystalizer::ByteFormat.new @buffer
    end
  end

  @buffers = Array(SerializerInstance).new

  # Serialize the message type to `Bytes`.
  def serialize(object : Message) : Bytes
    @log.trace { object }
    serializer = @buffers.find &.buffer.empty?
    if !serializer
      serializer = SerializerInstance.new
      @buffers << serializer
    end

    serializer.byte_format.serialize object.protocol_number
    serializer.byte_format.serialize object
    bytes = serializer.buffer.to_slice
    yield bytes
    serializer.buffer.clear
    bytes
  end

  module Message
    abstract def protocol_number : Int
  end

  macro included
  {% int = S.constants.size <= UInt8::MAX ? "u8" : "u16" %}
  {% int_type = S.constants.size <= UInt8::MAX ? UInt8 : UInt16 %}
  {% for type, i in S.constants %}
  struct {{type.id}}
    include CrystalByteProtocol::Server::Message
    def protocol_number : {{int_type.id}}
      {{i.id}}_{{int.id}}
    end
  end
  {% end %}
  end
end
