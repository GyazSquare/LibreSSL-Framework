# LibreSSL Framework

[![Build Status](https://travis-ci.org/GyazSquare/LibreSSL-Framework.svg?branch=master)](https://travis-ci.org/GyazSquare/LibreSSL-Framework)

LibreSSL framework is a porting framework of [LibreSSL](http://www.libressl.org) for OS X.

## LibreSSL Version

[2.9.2](https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.9.2-relnotes.txt)

## Requirements

* Xcode 11.2.1 (11B500)
* Base SDK: macOS 10.15
* Deployment Target: macOS 10.6
* Architectures: x86_64

## Installation

### Binary

Download the latest version of the `LibreSSL.framework.x.y.z.zip` file from the [Latest release](https://github.com/GyazSquare/LibreSSL-Framework/releases/latest) page, and embed it in your application bundle as a private framework. See [Embedding a Private Framework in Your Application Bundle](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/CreatingFrameworks.html#//apple_ref/doc/uid/20002258-106880) for information on how to embed a custom framework in your application.

### Source

Check out the source:

```shell
$ git clone https://github.com/GyazSquare/LibreSSL-Framework.git
```

## License

LibreSSL framework files are retained under the copyright of the authors. New additions are ISC licensed as per OpenBSD's normal licensing policy, or are placed in the public domain.

The LibreSSL code is distributed under the terms of the original LibreSSL licenses. See the LICENSE file for more info.
