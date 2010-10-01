from distutils.core import setup
from distutils.extension import Extension

version = '0.2'

cmdclass = {}
source_files = ['qrencode.c']

setup(
    name="pyqrencode",
    version="0.2",
    description="Python bindings for libqrencode",
    author="Matt Reiferson",
    author_email="mattr@bit.ly",
    url="http://github.com/bitly/pyqrencode",
    download_url="http://github.com/downloads/bitly/pyqrencode/pyqrencode-%s.tar.gz" % version,
    cmdclass=cmdclass,
    ext_modules=[Extension("qrencode", source_files, libraries=["qrencode"])]
)
