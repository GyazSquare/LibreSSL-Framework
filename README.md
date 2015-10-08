# LibreSSL Framework

LibreSSL framework is a porting framework of [LibreSSL](http://www.libressl.org) for OS X.

## Requirements

* Xcode 7 or later
* Base SDK: OS X 10.11 or later
* Deployment Target: OS X 10.5 or later
* Architectures: x86_64, i386

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
