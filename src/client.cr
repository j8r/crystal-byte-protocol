require "crystalizer/byte_format"

module CrystalByteProtocol::Client(C)
  # Deserialize the bytes message to an object. Returns `nil` if the first message byte does not match any type.
  def deserialize?(message : Bytes)
    if first = message[0]?
      object_message = message[1, message.size - 1]
      # Needed because using to_type? crash the program.
      {% for type, i in C.constants %}
      return Crystalizer::ByteFormat.deserialize(object_message, to: {{C.constant(type.id)}}) if first == {{i}}
      {% end %}
    end
  end
end
