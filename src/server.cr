require "log"
require "crystalizer/byte_format"

module CrystalByteProtocol::Server(S)
  property log : Log = Log.for("crystal-byte-protocol.serializer")

  def initialize
    @buffer = IO::Memory.new
    @byte_format = Crystalizer::ByteFormat.new @buffer
  end

  # Serializes the `Message` to `Bytes`.
  #
  # The bytes are a view of a buffer. If the method is called again, the buffer will change, and the bytes too.
  # Use `#dup` to copy and avoid the side effect. Another solution is to use a pool.
  def serialize(object : Message) : Bytes
    @log.trace { object }
    @buffer.clear

    @byte_format.serialize object.protocol_number
    @byte_format.serialize object
    @buffer.to_slice
  end

  def empty? : Bool
    @buffer.empty?
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
