from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import distutils.sysconfig as ds
config = ds.get_config_vars()

version = "0.1"

setup(
    name="pyqrencode",
    version="0.1",
    description="Python bindings for libqrencode",
    author="Matt Reiferson",
    author_email="mattr@bit.ly",
    url="http://github.com/bitly/pyqrencode",
    download_url="http://github.com/downloads/bitly/pyqrencode/pyqrencode-%s.tar.gz" % version,
    cmdclass = { "build_ext": build_ext },
    ext_modules = [Extension("qrencode", ["qrencode.pyx"], libraries=["qrencode"])]
)
