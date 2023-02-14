# Crystal Byte Protocol

[![CI](https://github.com/j8r/crystal-byte-protocol/workflows/CI/badge.svg)](https://github.com/j8r/crystal-byte-protocol/actions?query=workflow%3ACI)
[![Documentation](https://github.com/j8r/crystal-byte-protocol/workflows/Documentation/badge.svg)](https://j8r.github.io/crystal-byte-protocol)
[![ISC](https://img.shields.io/badge/License-ISC-blue.svg?style=flat-square)](https://en.wikipedia.org/wiki/ISC_license)

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  crystal-byte-protocol:
    github: j8r/crystal-byte-protocol
```

## Documentation

https://j8r.github.io/crystal-byte-protocol

## Usage

See the [specs](./specs) to have concrete examples.

### Generate JS protocol messages

In a `bin/gen-js-protocol-messages.cr` file:

```cr
require "crystal-byte-protocol/crystal_to_js_byte_format"
require "../src/protocol.cr"

dir = Path.new "../web-client/js/protocol"

CrystalByteProtocol::CrystalToJS.convert_to_file(
  dir / "Client.js",
  MyApp::Protocol::Client
)

CrystalByteProtocol::CrystalToJS.convert_to_file(
  dir / "Server.js",
  MyApp::Protocol::Server
)
```

### Use protocol messages in JS with WebSocket

Be sure to set the WebSocket binaryType to `"arraybuffer"`

```js
const socket = new WebSocket(address)
socket.binaryType = "arraybuffer"

this.socket.onmessage = (event) => {
  const message = Server.deserialize(new ByteDecoder(event.data))
  console.log(message)
}

const object = new Client.MyObject
socket.send(Client.serialize(new ByteEncoder(), object))
```

## License

Copyright (c) 2021-2023 Julien Reichardt - ISC License
